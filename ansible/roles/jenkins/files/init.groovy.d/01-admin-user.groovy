import jenkins.model.Jenkins
import hudson.security.HudsonPrivateSecurityRealm
import hudson.security.FullControlOnceLoggedInAuthorizationStrategy
import groovy.transform.CompileStatic

@CompileStatic
class JenkinsBootstrap {

    static void configureAdminUser() {
        Jenkins jenkins = Jenkins.instance

        // Skip setup if already configured
        boolean isHudsonRealm = HudsonPrivateSecurityRealm.isInstance(jenkins.securityRealm)
        boolean isFullControl = FullControlOnceLoggedInAuthorizationStrategy.isInstance(jenkins.authorizationStrategy)
        boolean hasUsers = jenkins.securityRealm.allUsers.size() > 0

        if (isHudsonRealm && isFullControl && hasUsers) {
            return
        }

        String username = System.getenv('JENKINS_ADMIN_USER')
        String password = System.getenv('JENKINS_ADMIN_PASS')

        HudsonPrivateSecurityRealm securityRealm = new HudsonPrivateSecurityRealm(false)
        securityRealm.createAccount(username, password)
        jenkins.securityRealm = securityRealm

        FullControlOnceLoggedInAuthorizationStrategy authorizationStrategy =
            new FullControlOnceLoggedInAuthorizationStrategy()
        authorizationStrategy.allowAnonymousRead = false
        jenkins.authorizationStrategy = authorizationStrategy

        jenkins.save()
    }

}

@CompileStatic
class JenkinsScriptEntryPoint {

    static void main(String[] args) {
        JenkinsBootstrap.configureAdminUser()
    }

}
