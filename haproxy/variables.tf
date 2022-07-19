data "template_file" "startup_script" {
    template = file("startup.sh.tpl")
}