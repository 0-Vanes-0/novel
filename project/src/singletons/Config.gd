extends Node

# ---------- CONSTANTS ----------

const alphaColor := Color(0.0, 0.0, 0.0, 0.0)
const halfAlphaColor := Color(1.0, 1.0, 1.0, 0.5)
const menuButtonColor := Color(1.0, 1.0, 1.0, 1.0)
const menuButtonSelectColor := Color(0.0, 1.0, 1.0, 1.0)

# ---------- CONSTANT OBJECTS ----------

#var projectileDictionary : Dictionary = { }
var buttonFont : DynamicFont

func fillConstants():
	buttonFont = DynamicFont.new()
	buttonFont.font_data = Preloader.overwatchFontData
	buttonFont.size = 40
#	buttonFont.extra_spacing_top = Global.buttonHeight / 10.0

# ---------- FUNTIONS ----------

#func fillDictionaries():
#	projectileDictionary["knife"] = {
#		"texture" : Preloader.knifeTexture,
#		"spriteSettings" : {
#			"scale" : 1.0,
#			"isRotated" : true
#		},
#		"speed" : Global.screenWidth / 2,
#		"damage" : 5
#	}
#	projectileDictionary["fire_orb"] = {
#		"texture" : Preloader.fireOrbTexture,
#		"spriteSettings" : {
#			"scale" : 3.0,
#			"isRotated" : false
#		},
#		"speed" : Global.screenWidth / 4,
#		"damage" : 5
#	}
#
#func createProjectile(nameOfProj : String) -> Projectile:
#	if(projectileDictionary.has(nameOfProj)):
#		var projType = projectileDictionary.get(nameOfProj)
#		var proj : Projectile = Preloader.projectile.instance()
#		proj.sprite.texture = projType.get("texture")
#		var scale = projType.get("spriteSettings").get("scale")
#		proj.scale = Vector2(scale, scale)
#		proj.isProjRotated = projType.get("spriteSettings").get("isRotated")
#		proj.speed = projType.get("speed")
#		proj.damage = projType.get("damage")
#		return proj
#	else:
#		Global.printError([self, "projectileDictionary has not key=", nameOfProj])
#		return null
