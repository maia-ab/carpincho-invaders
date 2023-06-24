import wollok.game.*
import portadas.*
import music.*
import niveles.*
import visuales.*

class Personaje{
	//var property y 
	//var property position = game.at(x, y)
	//method puedeMover(pos) = pos.x().between(0, 30) and pos.y().between(0, 30)
	//var property x = 5 
	var property position = 0
	var property image
	var property vidas
	method iniciar(){game.addVisual(self)}
	method colocarEn(pos){position = game.at(pos.x(), pos.y())} 
	method moverSi(dir, condicion){if(condicion){self.mover(dir)}}
	method sePuedeMoverA(dir) = dir.puedeMoverse(self)
	method mover(dir){dir.moverA(self)}
	method recibirDisparo(){
		if(vidas == 1){game.removeVisual(self)}
		else{vidas -= 1}
	}
	method disparar()
}

object jugador inherits Personaje(vidas = 3, position = game.at(5,0), image = "casa.png"){
	/*override method disparar(){
		const disp = new Disparo(x = self. x(), y = self.y()+1)
		game.addVisual(disp)
		disp.position(game.at(self.x(), disp.y()))
		game.onTick(100, "desplazarArriba", {disp.mover(arriba)})
	}
	override method iniciar(){self.configurarAcciones()}*/
	override method disparar(){
		const disp = new Disparo()
		disp.serDisparadoPor(self)
	}
	override method iniciar(){
		super()
		self.configurarAcciones()
	}
	method decirVidas(){game.say(self, "Tengo " + vidas + " vidas.")} 
	method configurarAcciones(){
		keyboard.left().onPressDo{self.mover(izquierda)}
		keyboard.right().onPressDo{self.mover(derecha)}
		keyboard.space().onPressDo{self.disparar()}
		keyboard.up().onPressDo{self.decirVidas()}
	}
	override method mover(dir){
		if (self.sePuedeMoverA(dir)){
			dir.moverA(self)
		}else{
			position = dir.posDeReinicio()
		}
	}
}

class Enemigo inherits Personaje (vidas = 1, image = "carpincho45.png"){
	//override method iniciar(){}
	/*override method disparar(){
		const disp = new Disparo(x = self. x(), y = self.y()+1)
		game.addVisual(disp)
		disp.position(game.at(self.x(), disp.y()))
		game.onTick(100, "desplazarAbajo", {self.mover(abajo)})
	}*/
	var property direccion = derecha
	
	override method iniciar(){
		super()
		game.onCollideDo(self, {x => self.recibirDisparo()})
		//self.mover()
		self.moverseEnGrupo()
	}
	override method disparar(){}
	method decirVidas(){game.say(self, "Tengo " + vidas + " vidas.")} 
	/* 
	method configurarAcciones(){
		keyboard.up().onPressDo{self.decirVidas()}
		keyboard.down().onPressDo{self.recibirDisparo()}
	}	*/
	//method mover(){
	method moverseEnGrupo(){
		self.patrullarDerecha()
		//game.onTick(20000, "patrullar", {self.cambiarDireccion()})
		game.onTick(16500, "patrullar", {self.cambiarDireccion()})
	}
	method patrullarDerecha(){
		//game.onTick(1000,"Movimiento",{derecha.moverA(self)})
		game.onTick(1000,"Movimiento",{self.mover(derecha)})
	}
	method patrullarIzquierda(){
		//game.onTick(1000,"Movimiento",{izquierda.moverA(self)})
		game.onTick(1000,"Movimiento",{self.mover(izquierda)})
	}
	method cambiarDireccion(){
		self.dejarDeMover()
		abajo.moverA(self)
		if (direccion.equals(derecha)){
			self.patrullarIzquierda()
			direccion=izquierda	
		}
		else {self.patrullarDerecha()
			  direccion=derecha
		}
	}
	method dejarDeMover(){
		game.removeTickEvent("Movimiento")
	}
}


object invasion{
	const property invasores = []
	
	method iniciar(){}
	method enemigoRandom() = invasores.get(0.randomUpTo(invasores.size()))
	method disparoRandom(){self.enemigoRandom().disparar()}
	//method atacar(){game.onTick(5000, "ataque", {self.disparoRandom()})}
	method atacar(){game.onTick(1000, "ataque", {self.disparoRandom()})}
	/* 
	method colocarFilaDeEnemigos(y){
		(1..12).forEach{x => self.aniadir(new Enemigo(position = game.at(x, y)))}
	}*/
	method colocarFilaDeEnemigos(y){ 
		(1..12).forEach{x => self.aniadir(new Enemigo(position = game.at(x, y) 
			
		))}

	}
	method aniadir(invasor){invasores.add(invasor)}
	method iniciarGrupo(){
		self.colocarFilaDeEnemigos(18)
		self.colocarFilaDeEnemigos(16)
		self.colocarFilaDeEnemigos(14)
		invasores.forEach({x=>x.iniciar()})
	}
	//method estaVacia(){invasores.isEmpty()}
}

class Disparo{
	//var property x
	//var property y=1
	//method serDisparadaPor(personaje){personaje.disparar()}
	var property image = "disparo.png"
	var property position = null
	method mover(dir){dir.moverA(self)}
	method colocarEn(pos){position = game.at(pos.x(), pos.y())}
	method detenerDisparo(){
		game.removeVisual(self)
		game.removeTickEvent("desplazarArriba")
	}
	method serDisparadoPor(personaje){
		game.addVisual(self)
		self.colocarEn(personaje.position().up(1))
		game.onTick(100, "desplazarArriba", {self.mover(arriba)})
		game.onCollideDo(self, {x => x.recibirDisparo() self.detenerDisparo()})
	}
}



//MOVIMIENTOS
object arriba{
	method puedeMoverse(personaje) = personaje.position().y()+1 < game.height()
	method moverA(personaje){
		if (not self.puedeMoverse(personaje)){
			game.removeVisual(personaje)
			game.removeTickEvent("desplazarArriba") //ARREGLAR
		}else{
			personaje.position(personaje.position().up(1))
		}
	}
}
object abajo{
	method puedeMoverse(personaje) = personaje.position().y()-1 > -1
	method moverA(personaje){
		personaje.position( personaje.position().down(1))
	}
}

object derecha{
	method posDeReinicio() = game.at(0,0)
	method puedeMoverse(personaje) = personaje.position().x()+1 < game.width()
	method moverA(personaje){
		personaje.position( personaje.position().right(1))
	}
}

object izquierda{
	method posDeReinicio() = game.at(game.width()-1,0)
	method puedeMoverse(personaje) = personaje.position().x()-1 > -1
	method moverA(personaje){
		personaje.position( personaje.position().left(1))
	}
}
