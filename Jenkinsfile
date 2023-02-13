@Library('xmos_jenkins_shared_library@v0.21.0')

def runningOn(machine) {
    println "Stage running on:"
    println machine
}

getApproval()
pipeline {
    agent none
    stages {
        stage ('Cross-platform Builds & Tests') {
            parallel {
                stage ('RPI Build & Test') {
                    agent {
                        label 'armv7l&&raspian'
                    }
                    stages {
                        stage ('Build') {
                            steps {
                                runningOn(env.NODE_NAME)
                                // fetch submodules
                                sh 'git submodule update --init --jobs 4'
                                // build
                                dir('build') {
                                    sh 'cmake -S .. -DTESTING=ON && make -j4'
                                    // archive RPI binaries
                                    sh 'mkdir rpi && cp xvf_host libdevice_* rpi/'
                                    archiveArtifacts artifacts: 'rpi/*', fingerprint: true
                                }
                            }
                        }
                        stage ('Create Python enviroment') {
                            steps {
                                //sh 'python3 -m venv .venv && source .venv/bin/activate && pip3 install -r requirements-dev.txt'
                                sh 'python3 -m venv .venv && source .venv/bin/activate && pip3 install pytest'
                            }
                        }
                        stage ('Test') {
                            steps {
                                dir('test') {
                                    sh 'source ../.venv/bin/activate && pytest -s'
                                }
                            }
                        }
                    } // stages
                    post {
                        cleanup {
                            cleanWs()
                        }
                    }
                } // RPI Build & Test
                stage ('Mac Build & Test') {
                    agent {
                        label 'macos&&x86_64'
                    }
                    stages {
                        stage ('Build') {
                            steps {
                                runningOn(env.NODE_NAME)
                                // fetch submodules
                                sh 'git submodule update --init --jobs 4'
                                // build
                                dir('build') {
                                    sh 'cmake -S .. -DTESTING=ON && make -j4'
                                    // archive Mac binaries
                                    sh 'mkdir mac_x86 && cp xvf_host mac_x86/'
                                    archiveArtifacts artifacts: 'mac_x86/*', fingerprint: true
                                }
                            }
                        }
                        stage ('Create Python enviroment') {
                            steps {
                                //sh 'python3 -m venv .venv && source .venv/bin/activate && pip3 install -r requirements-dev.txt'
                                sh 'python3 -m venv .venv && source .venv/bin/activate && pip3 install pytest'
                            }
                        }
                        stage ('Test') {
                            steps {
                                dir('test') {
                                    sh 'source ../.venv/bin/activate && pytest -s'
                                }
                            }
                        }
                    } // stages
                    post {
                        cleanup {
                            cleanWs()
                        }
                    }
                } // Mac Build & Test
                stage ('Windows Build & Test') {
                    agent {
                        label 'sw-bld-win0'
                    }
                    stages {
                        stage ('Build') {
                            steps {
                                runningOn(env.NODE_NAME)
                                // fetch submodules
                                bat 'git submodule update --init --jobs 4'
                                // build
                                dir('build') {
                                    bat 'call "%PROGRAMFILES(x86)%\\Microsoft Visual Studio\\2022\\BuildTools\\Common7\\Tools\\VsDevCmd.bat" && cmake -G "NMake Makefiles" -S .. -DTESTING=ON && nmake'
                                    // archive Mac binaries
                                    bat 'mkdir windows && cp xvf_host windows/'
                                    archiveArtifacts artifacts: 'windows/*', fingerprint: true
                                }
                            }
                        }
                        stage ('Create Python enviroment') {
                            steps {
                                bat 'python3 -m venv .venv && .venv\\Scripts\\activate && pip3 install pytest'
                            }
                        }
                        stage ('Test') {
                            steps {
                                dir('test') {
                                    bat '..\\.venv\\Scripts\\activate && pytest -s'
                                }
                            }
                        }
                    } // stages
                    post {
                        cleanup {
                            cleanWs()
                        }
                    }
                } // Windows Build & Test
            } // parallel
        } // Cross-platform Builds & Tests
    } // stages
} // pipeline
