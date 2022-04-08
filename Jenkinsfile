pipeline {
	agent any

	stages {
		stage('prepare build'){
			steps{
				cleanWs()

				fileOperations([folderCreateOperation('source')])
				dir('source'){
					checkout scm
				}
			}
		}

		stage('build-amd64'){
			steps{

				debianPbuilder additionalBuildResults: '', 
					architecture: '', 
					components: '', 
					distribution: 'bullseye', 
					keyring: '', 
					mirrorSite: 'http://deb.debian.org/debian', 
					pristineTarName: ''

				fingerprint 'binaries/*.deb'
			}
		}

		stage('build-armhf'){
			when { branch 'master' }
			steps{

				debianPbuilder additionalBuildResults: '', 
					architecture: 'armhf', 
					components: '', 
					distribution: 'bullseye', 
					keyring: '', 
					mirrorSite: 'http://deb.debian.org/debian', 
					pristineTarName: ''

				fingerprint 'binaries/*.deb'
			}
		}

		stage('upload-nightly'){
			when { branch 'master' }
			steps {
				rtUpload (
					serverId: 'rm5248-jfrog',
					spec: '''{
						"files": [{
						"pattern": "binaries*/*",
						"target": "test-repo-debian-local/pool/hi-app/",
						"props":"deb.distribution=bullseye;deb.component=main;deb.architecture=amd64"
						}]
					}''' )

				rtBuildInfo (
					// Optional - Maximum builds to keep in Artifactory.
					maxBuilds: 1,
					deleteBuildArtifacts: true,
				)

				rtPublishBuildInfo (
					serverId: 'rm5248-jfrog'
				)

			}
		}

		stage('upload-release'){
			when { buildingTag() }
			steps {
				rtUpload (
					serverId: 'rm5248-jfrog',
					spec: '''{
						"files": [{
						"pattern": "binaries*/*",
						"target": "test-repo-debian-release/pool/hi-app/",
						"props":"deb.distribution=bullseye;deb.component=main;deb.architecture=amd64"
						}]
					}''' )

				rtBuildInfo (
				)

				rtPublishBuildInfo (
					serverId: 'rm5248-jfrog'
				)

			}
		}
	}

}
