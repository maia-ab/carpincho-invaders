import wollok.game.*
import config.*
import juego.*
import niveles.*
import portadas.*

//(1..13).forEach { x => toni.sembrar(new Maiz(position= game.at(x, 5)))}
//const property posiciones = [8,14,20,26]
//method aniadir(arb){arbustos.add(arb)}

class Arbusto{
	const property arbustos = []
	var property vidas
	var property image = "arb1.png"

	method iniciar(){
		game.addVisualIn(self, game.at(2,3))
		game.onCollideDo(self, {x => self.recibirDisparo()})
	}
	method recibirDisparo(){
		vidas -= 1
		self.atacar()
	}
	method atacar(){
		if(vidas == 24){image = "arb2.png"}
	 	else if(vidas == 18){image = "arb3.png"}
	 	else if(vidas == 12){image = "arb4.png"}
	 	else if(vidas == 6){image = "arb5.png"}
	 	else if(vidas == 1){image = "arb7.png"}
	 	else if(vidas == 0){game.removeVisual(self)}
	}
}

object arbnivel1 inherits Arbusto(vidas = 30){
	override method iniciar(){
		super()	
		game.addVisualIn(new Arbusto(vidas=30), game.at(8,3))
		game.addVisualIn(new Arbusto(vidas=30), game.at(14,3))
		game.addVisualIn(new Arbusto(vidas=30), game.at(20,3))
		game.addVisualIn(new Arbusto(vidas=30), game.at(26,3)) 
	}
}

/* 
object arbnivel2 inherits Arbusto(vidas=10){
	override method iniciar(){
		super()
		game.addVisualIn(new Arbusto(vidas=5), game.at(8,3))
		game.addVisualIn(new Arbusto(vidas=5), game.at(14,3))
		game.addVisualIn(new Arbusto(vidas=5), game.at(20,3))
		game.addVisualIn(new Arbusto(vidas=5), game.at(26,3))
	}
}

object arbnivel3 inherits Arbusto(vidas=5){
	override method iniciar(){
		super()
		game.addVisualIn(new Arbusto(vidas=5), game.at(8,3))
		game.addVisualIn(new Arbusto(vidas=5), game.at(14,3))
		game.addVisualIn(new Arbusto(vidas=5), game.at(20,3))
		game.addVisualIn(new Arbusto(vidas=5), game.at(26,3))
	}
}*/