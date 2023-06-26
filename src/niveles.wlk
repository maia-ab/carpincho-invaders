import wollok.game.*
import juego.*
import music.*
import portadas.*
import config.*
import visuales.*


class Nivel{
	var property image
	var property siguiente
	
	method iniciar(){
		game.addVisualIn(self, game.at(0,0))
		jugador.iniciar()
		invasion.iniciarGrupo()
		invasion.atacar()
	}
}
object nivel1 inherits Nivel(image="nivel1.png", siguiente=nivel2){
	override method iniciar(){
		super()
		arbNivel1.iniciar()
	}
}
object nivel2 inherits Nivel(image="nivel2.png", siguiente=victoria){
	override method iniciar(){
		super()
		arbNivel2.iniciar()
	}
}