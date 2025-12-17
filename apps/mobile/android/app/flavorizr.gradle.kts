import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationId = "com.helping.dev"
            resValue(type = "string", name = "app_name", value = "Helping Hand (Dev)")
        }
        create("stg") {
            dimension = "flavor-type"
            applicationId = "com.helping.stg"
            resValue(type = "string", name = "app_name", value = "Helping Hand (Stg)")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.helping.app"
            resValue(type = "string", name = "app_name", value = "Helping Hand")
        }
    }
}