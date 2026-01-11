# Note: This requires User Administrator role in Entra ID.
# If permission errors occur, these resources might need to be created manually.

resource "azuread_group" "avd_users" {
  display_name     = "AVD-Users"
  security_enabled = true
}

resource "azuread_user" "lab_user1" {
  user_principal_name = "lab-user1@${var.domain_name}"
  display_name        = "Lab User 1"
  mail_nickname       = "lab-user1"
  password            = "TempPass123!@#"
  force_password_change = true
}

resource "azuread_user" "lab_user2" {
  user_principal_name = "lab-user2@${var.domain_name}"
  display_name        = "Lab User 2"
  mail_nickname       = "lab-user2"
  password            = "TempPass123!@#"
  force_password_change = true
}

resource "azuread_group_member" "user1_assignment" {
  group_object_id  = azuread_group.avd_users.object_id
  member_object_id = azuread_user.lab_user1.object_id
}

resource "azuread_group_member" "user2_assignment" {
  group_object_id  = azuread_group.avd_users.object_id
  member_object_id = azuread_user.lab_user2.object_id
}
