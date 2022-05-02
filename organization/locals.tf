locals {
  env_folders = {
        "orbit" = [
            "marketing",
            "IT",
        ],
  }
  bu_folders = [
    "digital-assets"
  ]
  folders = [
      "shared"
  ]
  association_list = flatten([
    for bu in keys(local.env_folders) : [
      for env in local.env_folders[bu] : {
        bu   = bu
        env = env
      }
    ]
  ])
}