import wollok.game.*
import juego.*
import music.*
import niveles.*
import visuales.*

class Visual{
	var property position = game.at(0,0)
	var property image
	method ejecutar(){
		game.addVisual(self)
	}
	method remover(){game.removeVisual(self)}
}

object inicio inherits Visual(image = "inicio.png"){
	override method ejecutar(){
		super()
		game.schedule(5000,{self.remover()})
	}
}
 
object menu inherits Visual(image = "menu.png"){
	const property reglas = new Visual(image = "reglas.png")
	const property ajustes = new Visual(image = "ajustes.png")
	
	override method ejecutar(){
		super()
		soundPrincipal.play()
		keyboard.enter().onPressDo{self.remover() invasion.atacar()} //CAMBIO
		keyboard.a().onPressDo({self.setting()})
	}
	method setting(){
		game.addVisual(ajustes)
		keyboard.backspace().onPressDo{game.removeVisual(ajustes)}
		keyboard.r().onPressDo{game.removeVisual(ajustes)}
		keyboard.p().onPressDo{game.removeVisual(ajustes)}
	}
}

object victoria inherits Visual(image = "victoria.png"){
	override method ejecutar(){
		super()
		soundVictoria.play()
		keyboard.r().onPressDo{self.siguientePartida()}
	}
	method siguientePartida(){}
}

object gameOver inherits Visual(image = "gameOver.png"){
	override method ejecutar(){
		super()
		soundGameOver.play()
		game.schedule(5000,{self.finalizar()})
	}
	method finalizar(){game.stop()}
}
