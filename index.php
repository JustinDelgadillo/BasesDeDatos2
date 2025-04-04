<?php
// Mostrar todos los errores
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Incluir archivo de conexión
require_once __DIR__ . '/conexion.php';

// Verificar si la conexión se estableció
if (!isset($conexion) || $conexion->connect_error) {
    die("Error: No se pudo conectar a la base de datos. " . $conexion->connect_error);
}

// Obtener semestre actual con validación
$semestre_actual = isset($_GET['semestre']) ? (int)$_GET['semestre'] : 1;
if ($semestre_actual < 1 || $semestre_actual > 9) {
    $semestre_actual = 1;
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Inscripciones</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <div class="container">
        <h1>Sistema de Inscripciones</h1>
        
        <form action="inscripcion.php" method="post">
            <h2>Datos del Alumno</h2>
            
            <div class="form-group">
                <label for="semestre">Semestre:</label>
                <select id="semestre" name="semestre" required onchange="this.form.submit()">
                    <?php for($i = 1; $i <= 9; $i++): ?>
                        <option value="<?= $i ?>" <?= $i == $semestre_actual ? 'selected' : '' ?>>
                            <?= $i ?>° Semestre
                        </option>
                    <?php endfor; ?>
                </select>
            </div>
            
            <div class="form-group">
                <label for="no_cuenta">Número de Cuenta:</label>
                <input type="text" id="no_cuenta" name="no_cuenta" required>
            </div>
            
            <div class="form-group">
                <label for="nombre">Nombre(s):</label>
                <input type="text" id="nombre" name="nombre" required>
            </div>
            
            <div class="form-group">
                <label for="apellido_paterno">Apellido Paterno:</label>
                <input type="text" id="apellido_paterno" name="apellido_paterno" required>
            </div>
            
            <div class="form-group">
                <label for="apellido_materno">Apellido Materno:</label>
                <input type="text" id="apellido_materno" name="apellido_materno" required>
            </div>
            
            <div class="form-group">
                <label for="correo">Correo Electrónico:</label>
                <input type="email" id="correo" name="correo" required>
            </div>
            
            <h2>Materias Disponibles - Semestre <?= $semestre_actual ?></h2>
            
            <div class="materias-container">
                <?php
                // Consulta para obtener materias del semestre seleccionado
                $sql = "SELECT m.id_materia, m.nombre_s, m.creditos, 
                        g.id_grupo, g.clave_grupo, g.turno, g.horario, g.aula,
                        CONCAT(p.nombre, ' ', p.apellido_paterno) AS profesor
                        FROM materia m
                        JOIN grupo g ON m.id_materia = g.id_materia
                        JOIN profesor p ON g.id_profesor = p.id_profesor
                        WHERE m.semestre = ?";
                
                $stmt = $conexion->prepare($sql);
                if (!$stmt) {
                    die("Error preparando la consulta: " . $conexion->error);
                }
                
                $stmt->bind_param("i", $semestre_actual);
                
                if (!$stmt->execute()) {
                    die("Error ejecutando la consulta: " . $stmt->error);
                }
                
                $result = $stmt->get_result();
                
                if ($result->num_rows === 0) {
                    echo '<div class="no-materias">No hay materias disponibles para este semestre.</div>';
                } else {
                    while($materia = $result->fetch_assoc()) {
                        echo '<div class="materia-card">';
                        echo "<h3>{$materia['nombre_s']} ({$materia['creditos']} créditos)</h3>";
                        echo "<p><strong>Grupo:</strong> {$materia['clave_grupo']}</p>";
                        echo "<p><strong>Horario:</strong> {$materia['horario']}</p>";
                        echo "<p><strong>Profesor:</strong> {$materia['profesor']}</p>";
                        echo "<p><strong>Aula:</strong> {$materia['aula']}</p>";
                        echo '<label><input type="checkbox" name="grupos[]" value="'.$materia['id_grupo'].'"> Seleccionar</label>';
                        echo '</div>';
                    }
                }
                ?>
            </div>
            
            <button type="submit" name="registrar">Registrar Inscripción</button>
        </form>
    </div>
</body>
</html>