#!groovy

import hudson.security.csrf.DefaultCrumbIssuer
import jenkins.model.Jenkins

def instance = Jenkins.getInstance()
// Enables CSRF protection by setting up a crumb issuer
// enabled in jenkins2.0 by default
instance.setCrumbIssuer(new DefaultCrumbIssuer(true))
instance.save()