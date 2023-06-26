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
	method siguienteNivel(){
		//if(invasion.estaVacia()){
			//game.clear() //nose
		//	siguiente.iniciar()
		//}
		//else if(jugador.vidas()== 0){gameOver.ejecutar()}
	}
}

object nivel1 inherits Nivel(image="nivel1.png", siguiente=nivel2){
	override method iniciar(){
		super()
		arbNivel1.iniciar()
		self.siguienteNivel()
	}
	/* 
	override method siguienteNivel(){
		if(invasion.estaVacia()){
			game.clear() //nose
			nivel2.iniciar()
		}
	}*/
}
object nivel2 inherits Nivel(image="nivel2.png", siguiente=nivel3){
	override method iniciar(){
		super()
		//arbNivel2.iniciar()
	}
	override method siguienteNivel(){}
}
object nivel3 inherits Nivel(image="nivel3.png", siguiente=null){
	override method iniciar(){
		super()
		//muebleNivel3.iniciar()
	}
}