import wollok.game.*
import juego.*

class Visual{
	var property position = game.at(0,0)
	method image() 
	method ejecutar()
	method remover()
}

/* 
class Niveles inherits Visual{
	const property niveles = []
	override method image() = ""
	override method ejecutar(){}
	override method remover(){}
}*/

object inicio inherits Visual{
	override method image() = "fondo.png"
	override method ejecutar(){
		game.addVisual(self)
		keyboard.enter().onPressDo{self.remover()}
	}
	override method remover(){
		game.removeVisual(self)
	}
}

object arena inherits Visual{
	override method image() = ""
	override method ejecutar(){
		game.addVisual(self)
		//keyboard.enter().onPressDo{self.remover()}
	}
	override method remover(){
		game.removeVisual(self)
	}
}

object gameOver inherits Visual{
	override method image() = ""
	override method ejecutar(){
		//if(){}   
		game.addVisual(self)
		keyboard.enter().onPressDo{self.remover()}
	}
	override method remover(){
		game.removeVisual(self)
	}
}

