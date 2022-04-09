void buildDebPkg_fn(String arch, String distro){
	debianPbuilder additionalBuildResults: '', 
			architecture: arch, 
			components: '', 
			distribution: distro, 
			keyring: '', 
			mirrorSite: 'http://deb.debian.org/debian', 
			pristineTarName: ''
}

node {
		stage('Clean'){
				cleanWs()
		}

		stage('Checkout'){
				fileOperations([folderCreateOperation('source')])
				dir('source'){
					def scmVars = checkout scm
					env.GIT_COMMIT = scmVars.GIT_COMMIT
				}

				printenv
		}

		stage("Build-${arch}-${distro}"){
			if( repoHook.length() > 0 ){
				configFileProvider([configFile(fileId: "${repoHook}", targetLocation: 'hookdir/D21-repo-hook')]){
					buildDebPkg_fn( arch, distro )
				}
			}else{
				buildDebPkg_fn( arch, distro )
			}
		} //stage

		stage('upload-nightly'){
			if( env.BRANCH_NAME == 'master' ){
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
			if( env.BRANCH_NAME == "tags"){
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


