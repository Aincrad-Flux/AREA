pipeline {
	agent any

	options {
		disableConcurrentBuilds()
		timestamps()
	}

	environment {
		GIT_AUTHOR_NAME = 'AREA Automation'
		GIT_AUTHOR_EMAIL = 'ci@aincrad-flux.dev'
		SERVER_REPO_URL = 'git@github.com:Aincrad-Flux/AREA-Server.git'
		WEB_REPO_URL = 'git@github.com:Aincrad-Flux/AREA-Web.git'
		MOBILE_REPO_URL = 'git@github.com:Aincrad-Flux/AREA-Mobile.git'
		SSH_CREDENTIALS_ID = 'github-https-tokens'
	}

	stages {
		stage('Checkout') {
			steps {
				cleanWs()
				checkout scm
			}
		}

		stage('Server ➜ AREA-Server') {
			when { expression { fileExists('server') } }
			steps {
				sshagent(credentials: [env.SSH_CREDENTIALS_ID]) {
					script {
						syncService(
							serviceLabel: 'server',
							serviceDir: 'server',
							repoUrl: env.SERVER_REPO_URL,
							targetBranch: resolveTargetBranch()
						)
					}
				}
			}
		}

		stage('Web ➜ AREA-Web') {
			when { expression { fileExists('web') } }
			steps {
				sshagent(credentials: [env.SSH_CREDENTIALS_ID]) {
					script {
						syncService(
							serviceLabel: 'web',
							serviceDir: 'web',
							repoUrl: env.WEB_REPO_URL,
							targetBranch: resolveTargetBranch()
						)
					}
				}
			}
		}

		stage('Mobile ➜ AREA-Mobile') {
			when { expression { fileExists('mobile') } }
			steps {
				sshagent(credentials: [env.SSH_CREDENTIALS_ID]) {
					script {
						syncService(
							serviceLabel: 'mobile',
							serviceDir: 'mobile',
							repoUrl: env.MOBILE_REPO_URL,
							targetBranch: resolveTargetBranch()
						)
					}
				}
			}
		}
	}

	post {
		always {
			cleanWs()
		}
	}
}

def resolveTargetBranch() {
	return env.BRANCH_NAME?.trim() ? env.BRANCH_NAME : 'main'
}

def syncService(Map args) {
	String label = args.serviceLabel
	String serviceDir = args.serviceDir
	String repoUrl = args.repoUrl
	String branch = args.targetBranch

	if (!fileExists(serviceDir)) {
		error "Directory '${serviceDir}' not found for service '${label}'."
	}

	dir("split/${label}") {
		deleteDir()

		sh """#!/bin/bash
		set -euo pipefail
		rsync -a --delete \\
			--exclude '.git/' \\
			--exclude '.dart_tool/' \\
			--exclude 'node_modules/' \\
			--exclude 'build/' \\
			--exclude '.gradle/' \\
			--exclude '.idea/' \\
			"${serviceDir}/" ./
		"""

		sh """#!/bin/bash
		set -euo pipefail
		git init
		git config user.name "${env.GIT_AUTHOR_NAME}"
		git config user.email "${env.GIT_AUTHOR_EMAIL}"
		if git remote | grep -q '^origin$'; then
			git remote remove origin
		fi
		git remote add origin "${repoUrl}"
		git checkout -B "${branch}"
		git add -A
		if git diff --cached --quiet; then
			echo "No changes detected for ${label}; skipping push."
			exit 0
		fi
		git commit -m "Sync ${label} from monorepo build #${env.BUILD_NUMBER ?: 'local'}"
		git push --force origin "${branch}"
		"""
	}
}
