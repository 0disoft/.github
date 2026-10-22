# Política de seguridad

Idioma: [English](../../../SECURITY.md) | [한국어](../ko/SECURITY.md) | Español | [Français](../fr/SECURITY.md) | [हिन्दी](../hi/SECURITY.md) | [简体中文](../zh-CN/SECURITY.md)

Esta es la política de seguridad predeterminada para los repositorios propiedad de 0disoft. Si un repositorio tiene su propio `SECURITY.md`, tendrá prioridad la política específica de ese repositorio.

## Repositorios admitidos

Los reportes de seguridad se revisan para los repositorios que se mantienen activamente.

Los repositorios archivados, experimentales, obsoletos o sin mantenimiento pueden no recibir correcciones de seguridad.

Salvo que un repositorio indique lo contrario, el trabajo de seguridad se gestiona en la medida de lo posible para la rama predeterminada y la última versión pública, si el repositorio utiliza releases.

## Requisitos de seguridad para contribuciones

Los cambios que introduzcan o modifiquen autenticación, autorización, criptografía, manejo de secretos, procesamiento de datos personales, pagos o comportamiento expuesto a la red requieren una revisión adicional por parte del mantenedor.

## Política de criptografía

Para cualquier cambio que introduzca, modifique o dependa de comportamiento criptográfico:

- No implementes criptografía propia ni combines primitivas criptográficas directamente sin aprobación explícita del mantenedor y una revisión de seguridad adecuada.
- Da preferencia a protocolos establecidos, bibliotecas bien mantenidas e implementaciones alineadas con procesos de estandarización.
- La criptografía simétrica y las funciones hash siguen estando permitidas. Usa cifrado autenticado moderno, autenticación de mensajes y primitivas hash mediante bibliotecas mantenidas.
- Las decisiones criptográficas deben ser configurables y reemplazables cuando sea práctico. Evita fijar algoritmos directamente en el código cuando exista negociación de protocolo o configuración de biblioteca.

### Criptografía de clave pública y PQC

- Para nuevas funciones de cifrado de clave pública, establecimiento de claves o firma digital, da preferencia a la criptografía poscuántica estandarizada por NIST cuando exista soporte listo para producción.
- Da preferencia a ML-KEM para nuevo establecimiento de claves, y a ML-DSA o SLH-DSA para nuevas firmas digitales cuando encajen con el protocolo y el entorno de ejecución.
- Haz seguimiento de otros algoritmos estandarizados por NIST o en proceso de estandarización, incluidos FN-DSA y HQC, a medida que maduren.
- Se permiten configuraciones híbridas, clásicas y poscuánticas, cuando sean necesarias por interoperabilidad, siempre que sigan un protocolo, perfil o estándar reconocido y respaldado por proveedores.
- El uso existente de RSA, Diffie-Hellman, ECDH, ECDSA o EdDSA puede mantenerse cuando sea necesario por compatibilidad, pero los nuevos secretos de larga duración, las nuevas raíces de confianza de larga duración y los nuevos diseños de protocolos criptográficos deben estar preparados para la transición poscuántica cuando sea práctico.
- No uses esquemas poscuánticos no estándar, experimentales o solo de investigación en código de producción sin aprobación explícita del mantenedor y revisión de seguridad.

El objetivo no es prohibir de inmediato toda la criptografía existente. El objetivo es evitar añadir dependencias innecesarias de clave pública vulnerables a computación cuántica y mantener los componentes criptográficos reemplazables.

## Política de almacenamiento de contraseñas

Si un proyecto almacena contraseñas de usuarios:

- No almacenes contraseñas en texto plano ni con cifrado reversible.
- No apliques hash a contraseñas directamente con funciones hash rápidas y de propósito general como MD5, SHA-1, SHA-256 o SHA-512.
- Da preferencia a Argon2id para el nuevo hashing de contraseñas.
- Usa un salt único, generado aleatoriamente, para cada contraseña. Para el hashing de contraseñas con Argon2id, se recomienda un salt de 16 bytes.
- Usa bibliotecas mantenidas y formatos estándar de hash de contraseñas cuando sea práctico.
- Los parámetros de Argon2id deben ser configurables y revisarse a medida que cambien el hardware y las restricciones de despliegue.
- Como base, usa al menos la configuración mínima de Argon2id recomendada por OWASP, salvo que una política específica del repositorio defina parámetros más estrictos: 19 MiB de memoria, 2 iteraciones y 1 grado de paralelismo.
- Si Argon2id no está disponible, usa scrypt cuando sea posible. En sistemas heredados, bcrypt puede mantenerse temporalmente con un factor de trabajo adecuado y un plan de migración. Si se requiere cumplimiento FIPS-140, usa PBKDF2-HMAC-SHA-256 con un factor de trabajo aprobado.
- No uses hashes rápidos, hashes sin salt ni esquemas propios de hashing de contraseñas.
- Almacena el algoritmo, los parámetros, el salt y la versión del hash junto con cada hash de contraseña para que puedan actualizarse con el tiempo.

## Política de tokens, claves API y secretos

Para tokens generados por máquina, claves API, códigos de recuperación y secretos similares:

- Genera secretos con un generador de números aleatorios criptográficamente seguro.
- No almacenes claves API, tokens de acceso, tokens de actualización, tokens de sesión ni códigos de recuperación en bruto, salvo que exista una necesidad operativa clara.
- Da preferencia a almacenar un hash con clave, un hash o un verificador no reversible cuando no sea necesario recuperar el texto original.
- Los secretos no deben subirse al repositorio, incluirse en logs, exponerse en mensajes de error ni almacenarse en datos de prueba.
- Usa un gestor de secretos, almacenamiento de secretos específico del entorno o el mecanismo cifrado de secretos que proporcione la plataforma para secretos operativos.

## Seguridad de dependencias y cadena de suministro

- Mantén las dependencias razonablemente actualizadas.
- Los cambios de dependencias relevantes para la seguridad deben revisarse antes de una release.
- No añadas dependencias para criptografía, autenticación, autorización, serialización, renderizado de plantillas o parsing de red sin revisión del mantenedor.

## Reportar una vulnerabilidad

No reportes vulnerabilidades de seguridad mediante issues, pull requests o discusiones públicas.

Reporta de forma privada a través de GitHub:

1. Abre el repositorio afectado, selecciona la pestaña **Security** y elige **Report a vulnerability**.
2. Si esa opción no está disponible o no puedes identificar el repositorio afectado, usa el [formulario de reporte privado de `0disoft/.github`](https://github.com/0disoft/.github/security/advisories/new). Es el repositorio de políticas predeterminadas y el punto de contacto alternativo de la cuenta.
3. Solo si ninguno de los dos canales de reporte privado está disponible, abre un issue que solo solicite un canal de contacto privado. No incluyas detalles técnicos, pasos de explotación ni versiones afectadas en ese issue.

Al reportar una vulnerabilidad, incluye:

- el repositorio afectado
- la versión, rama o commit afectado, si se conoce
- una descripción clara del problema
- pasos para reproducir el problema
- impacto potencial
- cualquier mitigación sugerida, si existe

## Gestión

Los reportes se revisarán de buena fe.

El mantenedor puede pedir detalles adicionales, preparar una corrección, coordinar la divulgación o determinar que el problema reportado no es una vulnerabilidad de seguridad.

Evita divulgar públicamente el problema hasta que se haya preparado una corrección o mitigación, salvo que el mantenedor no responda durante un periodo de tiempo irrazonable.
