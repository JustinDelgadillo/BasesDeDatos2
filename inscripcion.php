<?php
// Mostrar todos los errores
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Incluir archivo de conexión
require_once __DIR__ . '/conexion.php';

// Verificar si se envió el formulario
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['registrar'])) {
    // Recoger y sanitizar datos del formulario
    $no_cuenta = $conexion->real_escape_string($_POST['no_cuenta']);
    $nombre = $conexion->real_escape_string($_POST['nombre']);
    $apellido_paterno = $conexion->real_escape_string($_POST['apellido_paterno']);
    $apellido_materno = $conexion->real_escape_string($_POST['apellido_materno']);
    $correo = $conexion->real_escape_string($_POST['correo']);
    $semestre = (int)$_POST['semestre'];
    $grupos = isset($_POST['grupos']) ? $_POST['grupos'] : [];
    
    // Iniciar transacción
    $conexion->autocommit(false);
    $todos_exitosos = true;
    $mensajes = [];
    
    try {
        // 1. Registrar al alumno (o verificar si ya existe)
        $sql_alumno = "INSERT INTO alumno (nombre_s, apellido_paterno, apellido_materno, no_cuenta, correo, semestre) 
                       VALUES (?, ?, ?, ?, ?, ?)
                       ON DUPLICATE KEY UPDATE id_alumno=LAST_INSERT_ID(id_alumno)";
        
        $stmt_alumno = $conexion->prepare($sql_alumno);
        if (!$stmt_alumno) {
            throw new Exception("Error preparando consulta de alumno: " . $conexion->error);
        }
        
        $stmt_alumno->bind_param("sssssi", $nombre, $apellido_paterno, $apellido_materno, $no_cuenta, $correo, $semestre);
        
        if (!$stmt_alumno->execute()) {
            throw new Exception("Error registrando alumno: " . $stmt_alumno->error);
        }
        
        $id_alumno = $conexion->insert_id;
        
        // 2. Registrar inscripciones a grupos
        if (!empty($grupos)) {
            foreach ($grupos as $id_grupo) {
                $id_grupo = (int)$id_grupo;
                
                // Verificar cupo disponible
                $sql_cupo = "SELECT g.cupo, COUNT(i.id_inscripcion) AS inscritos
                             FROM grupo g
                             LEFT JOIN inscripcion i ON g.id_grupo = i.id_grupo
                             WHERE g.id_grupo = ?
                             GROUP BY g.id_grupo";
                
                $stmt_cupo = $conexion->prepare($sql_cupo);
                if (!$stmt_cupo) {
                    throw new Exception("Error verificando cupo: " . $conexion->error);
                }
                
                $stmt_cupo->bind_param("i", $id_grupo);
                $stmt_cupo->execute();
                $cupo = $stmt_cupo->get_result()->fetch_assoc();
                
                if ($cupo['inscritos'] >= $cupo['cupo']) {
                    $mensajes[] = "El grupo $id_grupo no tiene cupo disponible";
                    continue;
                }
                
                // Registrar inscripción
                $sql_inscripcion = "INSERT INTO inscripcion (id_alumno, id_grupo, estatus) 
                                     VALUES (?, ?, 'Activa')
                                     ON DUPLICATE KEY UPDATE estatus='Activa'";
                
                $stmt_inscripcion = $conexion->prepare($sql_inscripcion);
                if (!$stmt_inscripcion) {
                    throw new Exception("Error preparando inscripción: " . $conexion->error);
                }
                
                $stmt_inscripcion->bind_param("ii", $id_alumno, $id_grupo);
                
                if (!$stmt_inscripcion->execute()) {
                    throw new Exception("Error registrando inscripción: " . $stmt_inscripcion->error);
                }
                
                $mensajes[] = "Inscripción al grupo $id_grupo registrada correctamente";
            }
        } else {
            $mensajes[] = "No se seleccionaron grupos para inscribir";
        }
        
        // Confirmar transacción si todo fue bien
        $conexion->commit();
        
    } catch (Exception $e) {
        // Revertir transacción en caso de error
        $conexion->rollback();
        $todos_exitosos = false;
        $mensajes[] = "Error: " . $e->getMessage();
    }
    
    // Restaurar autocommit
    $conexion->autocommit(true);
    
    // Mostrar resultados
    echo '<!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Resultado de Inscripción</title>
        <link rel="stylesheet" href="css/styles.css">
    </head>
    <body>
        <div class="container">';
    
    if ($todos_exitosos) {
        echo '<div class="success">Inscripción completada con éxito</div>';
    } else {
        echo '<div class="error">Hubo problemas con la inscripción</div>';
    }
    
    foreach ($mensajes as $mensaje) {
        echo "<p>$mensaje</p>";
    }
    
    echo '<a href="index.php?semestre='.$semestre.'" class="btn">Volver</a>
        </div>
    </body>
    </html>';
    
    $conexion->close();
    exit();
}

// Si no es POST, redirigir al inicio
header("Location: index.php");
?>