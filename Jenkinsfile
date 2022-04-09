void buildDebPkg_fn(String arch, String distro, boolean isTag){
	debianPbuilder additionalBuildResults: '', 
			architecture: arch, 
			components: '', 
			distribution: distro, 
			keyring: '', 
			mirrorSite: 'http://deb.debian.org/debian', 
			pristineTarName: '',
			buildAsTag: isTag,
			generateArtifactorySpecFile: true,
			artifactoryRepoName: buildingTag ? 'test-repo-debian-local' : 'test-repo-debian-release'
}

def arch = "amd64"
def distro = "bullseye"
def repoHook = ""
def buildingTag = env.TAG_NAME != null

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

				sh 'printenv'
		}

		stage("Build-${arch}-${distro}"){
			if( repoHook.length() > 0 ){
				configFileProvider([configFile(fileId: "${repoHook}", targetLocation: 'hookdir/D21-repo-hook')]){
					buildDebPkg_fn( arch, distro, buildingTag )
				}
			}else{
				buildDebPkg_fn( arch, distro, buildingTag )
			}
		} //stage

		stage('upload-nightly'){
			if( env.BRANCH_NAME == 'master' ){
				rtUpload (
					serverId: 'rm5248-jfrog',
					specPath: 'artifactory-spec-debian-pbuilder/debian-pbuilder.spec'
				)

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
			if( env.TAG_NAME != null ){
				rtUpload (
					serverId: 'rm5248-jfrog',
					specPath: 'artifactory-spec-debian-pbuilder/debian-pbuilder.spec'
				)

				rtBuildInfo (
				)

				rtPublishBuildInfo (
					serverId: 'rm5248-jfrog'
				)

			}
		}
}


