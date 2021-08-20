if [ -z  " $ MAVEN_SKIP_RC " ] ;  então

  if [ -f / etc / mavenrc] ;  então
    . / etc / mavenrc
  fi

  if [ -f  " $ HOME /.mavenrc " ] ;  então
    .  " $ HOME /.mavenrc "
  fi

fi

# Suporte específico do sistema operacional. $ var _deve_ ser definido como verdadeiro ou falso.
cygwin = falso ;
darwin = falso ;
mingw = false
caso  " ` uname ` "  em
  CYGWIN * ) cygwin = true ;;
  MINGW * ) mingw = true ;;
  Darwin * ) darwin = true
    # Use / usr / libexec / java_home se disponível, caso contrário, volte para / Library / Java / Home
    # Veja https://developer.apple.com/library/mac/qa/qa1170/_index.html
    if [ -z  " $ JAVA_HOME " ] ;  então
      if [ -x  " / usr / libexec / java_home " ] ;  então
        export JAVA_HOME = " ` / usr / libexec / java_home ` "
      outro
        export JAVA_HOME = " / Library / Java / Home "
      fi
    fi
    ;;
esac

if [ -z  " $ JAVA_HOME " ] ;  então
  if [ -r / etc / gentoo-release] ;  então
    JAVA_HOME = ` java-config --jre-home `
  fi
fi

if [ -z  " $ M2_HOME " ] ;  então
  # # resolver links - $ 0 pode ser um link para a casa de maven
  PRG = " $ 0 "

  # precisa disso para links simbólicos relativos
  enquanto [ -h  " $ PRG " ] ;  Faz
    ls = ` ls -ld " $ PRG " `
    link = ` expr " $ ls "  :  ' . * -> \ (. * \) $ ' `
    se expr " $ link "  :  ' /.* '  > / dev / null ;  então
      PRG = " $ link "
    outro
      PRG = " ` dirname " $ PRG " ` / $ link "
    fi
  feito

  saveddir = ` PWD `

  M2_HOME = ` dirname " $ PRG " ` / ..

  # torná-lo totalmente qualificado
  M2_HOME = ` cd " $ M2_HOME "  && pwd `

  cd  " $ saveddir "
  # echo Usando m2 em $ M2_HOME
fi

# Para Cygwin, certifique-se de que os caminhos estejam no formato UNIX antes de tocar em qualquer coisa
if  $ cygwin  ;  então
  [ -n  " $ M2_HOME " ] &&
    M2_HOME = ` cygpath --unix " $ M2_HOME " `
  [ -n  " $ JAVA_HOME " ] &&
    JAVA_HOME = ` cygpath --unix " $ JAVA_HOME " `
  [ -n  " $ CLASSPATH " ] &&
    CLASSPATH = ` cygpath --path --unix " $ CLASSPATH " `
fi

# Para Mingw, certifique-se de que os caminhos estejam no formato UNIX antes de tocar em qualquer coisa
if  $ mingw  ;  então
  [ -n  " $ M2_HOME " ] &&
    M2_HOME = " ` (cd " $ M2_HOME " ; pwd) ` "
  [ -n  " $ JAVA_HOME " ] &&
    JAVA_HOME = " ` (cd " $ JAVA_HOME " ; pwd) ` "
fi

if [ -z  " $ JAVA_HOME " ] ;  então
  javaExecutable = " ` which javac ` "
  if [ -n  " $ javaExecutable " ] &&  ! [ " ` expr \ " $ javaExecutable \"  :  ' \ ([^] * \) ' ` "  =  " não " ] ;  então
    # readlink (1) não está disponível como padrão no Solaris 10.
    READLINK = ` que readlink `
    if [ !  ` expr " $ readLink "  :  ' \ ([^] * \) ' `  =  " não " ] ;  então
      if  $ darwin  ;  então
        javaHome = " ` dirname \ " $ javaExecutable \" ` "
        javaExecutable = " ` cd \ " $ javaHome \"  &&  pwd -P ` / javac "
      outro
        javaExecutable = " ` readlink -f \ " $ javaExecutable \" ` "
      fi
      javaHome = " ` dirname \ " $ javaExecutable \" ` "
      javahome = ` expr " $ javahome "  :  ' (. * \) \ / bin ' `
      JAVA_HOME = " $ javaHome "
      exportar JAVA_HOME
    fi
  fi
fi

if [ -z  " $ JAVACMD " ] ;  então
  if [ -n  " $ JAVA_HOME "   ] ;  então
    if [ -x  " $ JAVA_HOME / jre / sh / java " ] ;  então
      # O JDK da IBM no AIX usa locais estranhos para os executáveis
      JAVACMD = " $ JAVA_HOME / jre / sh / java "
    outro
      JAVACMD = " $ JAVA_HOME / bin / java "
    fi
  outro
    JAVACMD = " ` qual java ` "
  fi
fi

if [ !  -x  " $ JAVACMD " ] ;  então
  echo  " Erro: JAVA_HOME não está definido corretamente. "  > & 2
  echo  "   Não podemos executar $ JAVACMD "  > & 2
  saída 1
fi

if [ -z  " $ JAVA_HOME " ] ;  então
  echo  " Aviso: a variável de ambiente JAVA_HOME não está definida. "
fi

CLASSWORLDS_LAUNCHER = org.codehaus.plexus.classworlds.launcher.Launcher

# atravessa a estrutura de diretório do diretório de trabalho do processo para a raiz do sistema de arquivos
# o primeiro diretório com subdiretório .mvn é considerado o diretório base do projeto
find_maven_basedir () {

  if [ -z  " $ 1 " ]
  então
    echo  " Caminho não especificado para find_maven_basedir "
    retorno 1
  fi

  basedir = " $ 1 "
  wdir = " $ 1 "
  enquanto [ " $ wdir "  ! =  ' / ' ] ;  Faz
    if [ -d  " $ wdir " /.mvn] ;  então
      basedir = $ wdir
      quebrar
    fi
    # solução alternativa para JBEAP-8937 (no Solaris 10 / Sparc)
    if [ -d  " $ {wdir} " ] ;  então
      wdir = ` cd " $ wdir / .. " ; pwd `
    fi
    # fim da solução alternativa
  feito
  echo  " $ {basedir} "
}

# concatena todas as linhas de um arquivo
concat_lines () {
  if [ -f  " $ 1 " ] ;  então
    echo  " $ ( tr -s ' \ n '  '  '  <  " $ 1 " ) "
  fi
}

BASE_DIR = ` find_maven_basedir " $ ( pwd ) " `
if [ -z  " $ BASE_DIR " ] ;  então
  saída 1 ;
fi

# #################################################### ##################################################
# Extensão para permitir o download automático do maven-wrapper.jar do Maven-central
# Isso permite usar o wrapper maven em projetos que proíbem a verificação de dados binários.
# #################################################### ##################################################
if [ -r  " $ BASE_DIR /.mvn/wrapper/maven-wrapper.jar " ] ;  então
    if [ " $ MVNW_VERBOSE "  =  verdadeiro ] ;  então
      echo  " Encontrado .mvn / wrapper / maven-wrapper.jar "
    fi
outro
    if [ " $ MVNW_VERBOSE "  =  verdadeiro ] ;  então
      echo  " Não foi possível encontrar .mvn / wrapper / maven-wrapper.jar, baixando-o ... "
    fi
    if [ -n  " $ MVNW_REPOURL " ] ;  então
      jarUrl = " $ MVNW_REPOURL /io/takari/maven-wrapper/0.5.6/maven-wrapper-0.5.6.jar "
    outro
      jarUrl = " https://repo.maven.apache.org/maven2/io/takari/maven-wrapper/0.5.6/maven-wrapper-0.5.6.jar "
    fi
    enquanto IFS = " = "  lê o valor da chave ;  Faz
      case  " $ key "  em (wrapperUrl) jarUrl = " $ value " ;  quebrar ;;
      esac
    feito  <  " $ BASE_DIR /.mvn/wrapper/maven-wrapper.properties "
    if [ " $ MVNW_VERBOSE "  =  verdadeiro ] ;  então
      echo  " Baixando de: $ jarUrl "
    fi
    wrapperJarPath = " $ BASE_DIR /.mvn/wrapper/maven-wrapper.jar "
    if  $ cygwin ;  então
      wrapperJarPath = ` cygpath --path --windows " $ wrapperJarPath " `
    fi

    se o  comando -v wget > / dev / null ;  então
        if [ " $ MVNW_VERBOSE "  =  verdadeiro ] ;  então
          echo  " Wget encontrado ... usando wget "
        fi
        if [ -z  " $ MVNW_USERNAME " ] || [ -z  " $ MVNW_PASSWORD " ] ;  então
            wget " $ jarUrl " -O " $ wrapperJarPath "
        outro
            wget --http-user = $ MVNW_USERNAME --http-password = $ MVNW_PASSWORD  " $ jarUrl " -O " $ wrapperJarPath "
        fi
     comando elif -v curl > / dev / null ;  então
        if [ " $ MVNW_VERBOSE "  =  verdadeiro ] ;  então
          echo  " Curl encontrado ... usando curl "
        fi
        if [ -z  " $ MVNW_USERNAME " ] || [ -z  " $ MVNW_PASSWORD " ] ;  então
            curl -o " $ wrapperJarPath "  " $ jarUrl " -f
        outro
            curl --user $ MVNW_USERNAME : $ MVNW_PASSWORD -o " $ wrapperJarPath "  " $ jarUrl " -f
        fi

    outro
        if [ " $ MVNW_VERBOSE "  =  verdadeiro ] ;  então
          echo  " Voltando a usar Java para fazer download "
        fi
        javaClass = " $ BASE_DIR /.mvn/wrapper/MavenWrapperDownloader.java "
        # Para Cygwin, mude os caminhos para o formato do Windows antes de executar javac
        if  $ cygwin ;  então
          javaClass = ` cygpath --path --windows " $ javaClass " `
        fi
        if [ -e  " $ javaClass " ] ;  então
            if [ !  -e  " $ BASE_DIR /.mvn/wrapper/MavenWrapperDownloader.class " ] ;  então
                if [ " $ MVNW_VERBOSE "  =  verdadeiro ] ;  então
                  echo  " - Compilando MavenWrapperDownloader.java ... "
                fi
                # Compilando a classe Java
                ( " $ JAVA_HOME / bin / javac "  " $ javaClass " )
            fi
            if [ -e  " $ BASE_DIR /.mvn/wrapper/MavenWrapperDownloader.class " ] ;  então
                # Executando o downloader
                if [ " $ MVNW_VERBOSE "  =  verdadeiro ] ;  então
                  echo  " - Executando MavenWrapperDownloader.java ... "
                fi
                ( " $ JAVA_HOME / bin / java " -cp .mvn / wrapper MavenWrapperDownloader " $ MAVEN_PROJECTBASEDIR " )
            fi
        fi
    fi
fi
# #################################################### ##################################################
# Fim da extensão
# #################################################### ##################################################

exportar MAVEN_PROJECTBASEDIR = $ {MAVEN_BASEDIR : - " $ BASE_DIR " }
if [ " $ MVNW_VERBOSE "  =  verdadeiro ] ;  então
  echo  $ MAVEN_PROJECTBASEDIR
fi
MAVEN_OPTS = " $ ( concat_lines " $ MAVEN_PROJECTBASEDIR /.mvn/jvm.config " )  $ MAVEN_OPTS "

# Para Cygwin, mude os caminhos para o formato Windows antes de executar o java
if  $ cygwin ;  então
  [ -n  " $ M2_HOME " ] &&
    M2_HOME = ` cygpath --path --windows " $ M2_HOME " `
  [ -n  " $ JAVA_HOME " ] &&
    JAVA_HOME = ` cygpath --path --windows " $ JAVA_HOME " `
  [ -n  " $ CLASSPATH " ] &&
    CLASSPATH = ` cygpath --path --windows " $ CLASSPATH " `
  [ -n  " $ MAVEN_PROJECTBASEDIR " ] &&
    MAVEN_PROJECTBASEDIR = ` cygpath --path --windows " $ MAVEN_PROJECTBASEDIR " `
fi

# Fornece uma maneira "padronizada" de recuperar os argumentos CLI que irão
# trabalha com execuções Windows e não Windows.
MAVEN_CMD_LINE_ARGS = " $ MAVEN_CONFIG  $ @ "
exportar MAVEN_CMD_LINE_ARGS

WRAPPER_LAUNCHER = org.apache.maven.wrapper.MavenWrapperMain

exec  " $ JAVACMD " \
  $ MAVEN_OPTS \
  -classpath " $ MAVEN_PROJECTBASEDIR /.mvn/wrapper/maven-wrapper.jar " \
  " -Dmaven.home = $ {M2_HOME} "  " -Dmaven.multiModuleProjectDirectory = $ {MAVEN_PROJECTBASEDIR} " \
  $ {WRAPPER_LAUNCHER}  $ MAVEN_CONFIG  " $ @ "
