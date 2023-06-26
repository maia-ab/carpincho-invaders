import wollok.game.*
import config.*
import juego.*
import niveles.*
import portadas.*

class Obstaculos{
	const property obstaculos = []
	var property vidas
	var property image = "arbusto.png"
	
	method iniciar(){
		self.aniadirGrupo(2,3)
		self.aniadirGrupo(8,9)
		self.aniadirGrupo(14,15)
		self.aniadirGrupo(20,21)
		self.aniadirGrupo(26,27)
		game.onCollideDo(self, {x => self.recibirDisparoDe(x)}) 
	}
	method aniadirGrupo(uno,dos){
		game.addVisualIn(new Obstaculos(vidas=vidas), game.at(uno,3))
		game.addVisualIn(new Obstaculos(vidas=vidas), game.at(dos,3))
	}
	method recibirDisparoDe(personaje){
		vidas -= 1
		self.atacar()
	}
	method atacar(){
		if(vidas == 12){image = "arb3.png"}
	 	else if(vidas == 8){image = "arb4.png"}
	 	else if(vidas == 4){image = "arb5.png"}
	 	else if(vidas == 2){image = "arb6.png"}
	 	else if(vidas == 0){game.removeVisual(self)}
	}
}

object arbNivel1 inherits Obstaculos(vidas=10){}
object arbNivel2 inherits Obstaculos(vidas=5){}
