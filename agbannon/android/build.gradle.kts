allprojects {
    repositories {
        google()
        mavenCentral()
    }

    classpath "com.android.tools.build:gradle:7.4.0"  // exemple de version d'Android Gradle Plugin
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0"  // Plugin Kotlin
}


val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
