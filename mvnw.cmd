@ REM ------------------------------------------------ ----------------------------
@ REM Licenciado para a Apache Software Foundation (ASF) sob um
@ REM ou mais contratos de licença de contribuidor. Veja o arquivo AVISO
@ REM distribuído com este trabalho para informações adicionais
@ REM em relação à propriedade dos direitos autorais. A ASF licencia este arquivo
@ REM para você sob a Licença Apache, Versão 2.0 (o
@ REM "Licença"); você não pode usar este arquivo, exceto em conformidade
@ REM com a licença. Você pode obter uma cópia da Licença em
@ REM
@ REM     https://www.apache.org/licenses/LICENSE-2.0
@ REM
@ REM A menos que exigido pela lei aplicável ou acordado por escrito,
O software @ REM distribuído sob a Licença é distribuído em um
@ REM "TAL COMO ESTÁ", SEM GARANTIAS OU CONDIÇÕES DE QUALQUER
@ REM KIND, expresso ou implícito. Veja a Licença para o
@ REM idioma específico que rege permissões e limitações
@ REM sob a Licença.
@ REM ------------------------------------------------ ----------------------------

@ REM ------------------------------------------------ ----------------------------
@ REM Maven Start Up Batch script
@ REM
@ REM Requerido ENV vars:
@ REM JAVA_HOME - localização de um diretório inicial JDK
@ REM
@ REM ENV vars opcionais
@ REM M2_HOME - localização do diretório inicial instalado do maven2
@ REM MAVEN_BATCH_ECHO - defina como 'on' para permitir o eco dos comandos em lote
@ REM MAVEN_BATCH_PAUSE - defina como 'on' para esperar por um pressionamento de tecla antes de terminar
@ REM MAVEN_OPTS - parâmetros passados ​​para o Java VM ao executar o Maven
@ REM,      por exemplo, para depurar o próprio Maven, use
@ REM set MAVEN_OPTS = -Xdebug -Xrunjdwp: transport = dt_socket, server = y, suspend = y, address = 8000
@ REM MAVEN_SKIP_RC - sinalizar para desabilitar o carregamento de arquivos mavenrc
@ REM ------------------------------------------------ ----------------------------

@ REM Comece todas as linhas REM com '@' no caso de MAVEN_BATCH_ECHO estar 'ligado'
@ echo  off
@ REM define o título da janela de comando
título  % 0
@ REM ativa o eco definindo MAVEN_BATCH_ECHO como 'ligado'
@ if " % MAVEN_BATCH_ECHO% "  ==  " on "   echo  % MAVEN_BATCH_ECHO%

@ REM definir% HOME% para o equivalente a $ HOME
if  " % HOME% "  ==  " " (defina " HOME = % HOMEDRIVE %% HOMEPATH% " )

@ REM Executa um script definido pelo usuário antes deste
se  não  " % MAVEN_SKIP_RC% "  ==  " "  goto skipRcPre
@ REM verifica o pré-script, uma vez com o final .bat legado e uma vez com o final .cmd
se  existir  " % HOME% \ mavenrc_pre.bat "  chame  " % HOME% \ mavenrc_pre.bat "
se  existir  " % HOME% \ mavenrc_pre.cmd "  chame  " % HOME% \ mavenrc_pre.cmd "
: skipRcPre

@ setlocal

definir  ERROR_CODE = 0

@ REM Para isolar variáveis ​​internas de possíveis pós-scripts, usamos outro setlocal
@ setlocal

@ REM ==== INICIAR VALIDAÇÃO ====
se  não  " % JAVA_HOME% "  ==  " "  goto OkJHome

eco .
echo Error: JAVA_HOME não encontrado em seu ambiente. > & 2
echo Defina a variável JAVA_HOME em seu ambiente para corresponder ao > & 2
echo localização de sua instalação Java. > & 2
eco .
ir para o erro

: OkJHome
se  existir  " % JAVA_HOME% \ bin \ java.exe "  goto init

eco .
echo Error: JAVA_HOME está definido para um diretório inválido. > & 2
echo JAVA_HOME = " % JAVA_HOME% "  > & 2
echo Defina a variável JAVA_HOME em seu ambiente para corresponder ao > & 2
echo localização de sua instalação Java. > & 2
eco .
ir para o erro

@ REM ==== VALIDAÇÃO FINAL ====

: init

@ REM Encontre o diretório base do projeto, ou seja, o diretório que contém a pasta ".mvn".
@ REM Fallback para o diretório de trabalho atual se não for encontrado.

definir  MAVEN_PROJECTBASEDIR = % MAVEN_BASEDIR%
SE  NÃO  " % MAVEN_PROJECTBASEDIR% " == " "  goto endDetectBaseDir

definir  EXEC_DIR = % CD%
definir  WDIR = % EXEC_DIR%
: findBaseDir
IF  EXIST  " % WDIR% " \ .mvn Goto baseDirFound
cd ..
IF  " % WDIR% " == " % CD% "  goto baseDirNotFound
definir  WDIR = % CD%
goto findBaseDir

: baseDirFound
definir  MAVEN_PROJECTBASEDIR = % WDIR%
cd  " % EXEC_DIR% "
goto endDetectBaseDir

: baseDirNotFound
definir  MAVEN_PROJECTBASEDIR = % EXEC_DIR%
cd  " % EXEC_DIR% "

: endDetectBaseDir

SE  NÃO  EXIST  " % MAVEN_PROJECTBASEDIR% \ .mvn \ jvm.config "  Goto endReadAdditionalConfig

@ setlocal EnableExtensions EnableDelayedExpansion
para / F " usebackq delims = "  %% a  em ( " % MAVEN_PROJECTBASEDIR% \ .mvn \ jvm.config " ) não  definir  JVM_CONFIG_MAVEN_PROPS = ! JVM_CONFIG_MAVEN_PROPS!  %%uma
@ endlocal  &  definir  JVM_CONFIG_MAVEN_PROPS = % JVM_CONFIG_MAVEN_PROPS%

: endReadAdditionalConfig

SET  MAVEN_JAVA_EXE = " % JAVA_HOME% \ bin \ java.exe "
definir  WRAPPER_JAR = " % MAVEN_PROJECTBASEDIR% \ .mvn \ wrapper \ maven-wrapper.jar "
definir  WRAPPER_LAUNCHER = org.apache.maven.wrapper.MavenWrapperMain

definir  DOWNLOAD_URL = " https://repo.maven.apache.org/maven2/io/takari/maven-wrapper/0.5.6/maven-wrapper-0.5.6.jar "

FOR / F " tokens = 1,2 delims == "  %% A  IN ( " % MAVEN_PROJECTBASEDIR% \ .mvn \ wrapper \ maven-wrapper.properties " ) DO (
    IF  " %% A " == " wrapperUrl "  SET  DOWNLOAD_URL = %% B
)

Extensão @ REM para permitir o download automático do maven-wrapper.jar do Maven-central
@ REM Isso permite o uso do invólucro maven em projetos que proíbem a verificação de dados binários.
se  existir  % WRAPPER_JAR% (
    se  " % MVNW_VERBOSE% "  ==  " verdadeiro " (
        echo encontrado % WRAPPER_JAR%
    )
) mais (
    se  não  " % MVNW_REPOURL% "  ==  " " (
        SET  DOWNLOAD_URL = " % MVNW_REPOURL% /io/takari/maven-wrapper/0.5.6/maven-wrapper-0.5.6.jar "
    )
    se  " % MVNW_VERBOSE% "  ==  " verdadeiro " (
        echo Não foi possível encontrar % WRAPPER_JAR% , baixando ...
        echo Baixando de: % DOWNLOAD_URL%
    )

    powershell -Command " & { " ^
		" $ webclient = new-object System.Net.WebClient; " ^
		" if (-not ([string] :: IsNullOrEmpty (' % MVNW_USERNAME% ') -and [string] :: IsNullOrEmpty (' % MVNW_PASSWORD% '))) { " ^
		" $ webclient.Credentials = new-object System.Net.NetworkCredential (' % MVNW_USERNAME% ', ' % MVNW_PASSWORD% '); " ^
		" } " ^
		" [Net.ServicePointManager] :: SecurityProtocol = [Net.SecurityProtocolType] :: Tls12; $ webclient.DownloadFile (' % DOWNLOAD_URL% ', ' % WRAPPER_JAR% ') " ^
		" } "
    se  " % MVNW_VERBOSE% "  ==  " verdadeiro " (
        echo Download concluído % WRAPPER_JAR%
    )
)
@ REM Fim da extensão

@ REM Fornece uma maneira "padronizada" de recuperar os argumentos CLI que irão
@ REM funciona com execuções Windows e não Windows.
definir  MAVEN_CMD_LINE_ARGS = % *

% MAVEN_JAVA_EXE%  % JVM_CONFIG_MAVEN_PROPS%  % MAVEN_OPTS%  % MAVEN_DEBUG_OPTS% -classpath % WRAPPER_JAR%  " -Dmaven.multiModuleProjectDirectory = % MAVEN_PROJECTBASEDIR% "  % WRAPPER_LAUNCHER%  % MAVEN_CONFIG%  % *
if  ERRORLEVEL  1  goto error
ir para o fim

: erro
definir  ERROR_CODE = 1

: fim
@ endlocal  &  definir  ERROR_CODE = % ERROR_CODE%

se  não  " % MAVEN_SKIP_RC% "  ==  " "  goto skipRcPost
@ REM verifica o post script, uma vez com o final .bat legado e uma vez com o final .cmd
se  existir  " % HOME% \ mavenrc_post.bat "  chame  " % HOME% \ mavenrc_post.bat "
se  existir  " % HOME% \ mavenrc_post.cmd "  chame  " % HOME% \ mavenrc_post.cmd "
: skipRcPost

@ REM pausar o script se MAVEN_BATCH_PAUSE estiver definido como 'ligado'
if  " % MAVEN_BATCH_PAUSE% "  ==  " on "  pausa

se  " % MAVEN_TERMINATE_CMD% "  ==  " on "  saia  % ERROR_CODE%

sair / B % ERROR_CODE%
