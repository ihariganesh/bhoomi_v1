allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects.filter { it.name != "app" }.forEach { proj ->
    val newSubprojectBuildDir: Directory = newBuildDir.dir(proj.name)
    proj.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    // Do not force evaluation of ':app' here because it triggers Android SDK discovery
    // during root project configuration and can fail when sdk.dir or ANDROID_HOME is not set.
    // If you need to evaluate :app for a specific reason, perform that later (for example,
    // in a task's doFirst/doLast or via task dependencies) so SDK lookup happens only when required.
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
