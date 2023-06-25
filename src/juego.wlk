import wollok.game.*
import portadas.*
import music.*
import niveles.*
import visuales.*

class Personaje{
	var property puedeDisparar=true
	var property position = 0
	var property image
	var property vidas
	var property velocidadDeDisparo
	method iniciar(){game.addVisual(self)}
	method colocarEn(pos){position = game.at(pos.x(), pos.y())} 
	method moverSi(dir, condicion){if(condicion){self.mover(dir)}}
	method sePuedeMoverA(dir) = dir.puedeMoverse(self)
	method mover(dir){dir.moverA(self)}
	method recibirDisparoDe(personaje){
		if(vidas == 1){game.removeVisual(self)}
		else{vidas -= 1}
	}
	method disparar(dir)
}


object jugador inherits Personaje(vidas = 3, position = game.at(5,0), image = "casa.png", velocidadDeDisparo = 80){
	var property vida1=new Vida(position=game.at(0,19))
	var property vida2=new Vida(position=game.at(1,19))
	var property vida3=new Vida(position=game.at(2,19))
	override method disparar(dir){
		const disp = new Disparo(position = self.position().up(1), image = "disparo.png")
		if(puedeDisparar){
			disp.serDisparadoPor(self, dir)
			puedeDisparar=false
			game.schedule(1500,{puedeDisparar=true})
		}
	}
	override method recibirDisparoDe(personaje){
		if(vidas == 1){
			game.removeVisual(vida1)
			invasion.detenerAtaque()
			game.removeVisual(self)
			gameOver.ejecutar()
			puedeDisparar=false
					   
		}else if(vidas == 2){
			game.removeVisual(vida2)
			vidas -=1
		}else{
			game.removeVisual(vida3)
			vidas -=1			
		}
	}
	override method iniciar(){
		super()
		self.configurarAcciones()
		self.mostrarVidas()
	}
	method configurarAcciones(){
		keyboard.left().onPressDo{self.mover(izquierda)}
		keyboard.right().onPressDo{self.mover(derecha)}
		keyboard.space().onPressDo{self.disparar(arriba)}
		
	}
	method mostrarVidas(){
		game.addVisual(vida1)
		game.addVisual(vida2)
		game.addVisual(vida3)		
	}
}

class Vida{
	var property position
	var property image= "vida.png"
}

class Enemigo inherits Personaje (vidas = 1, image = "carpincho45.png"){
	var property direccion = derecha
	override method iniciar(){
		super()
		self.moverseEnGrupo()
	}
	override method recibirDisparoDe(personaje){
		if (personaje.equals(jugador)){
			game.removeVisual(self)
		}
	}
	method decirVidas(){game.say(self, "Tengo " + vidas + " vidas.")} 
	method moverseEnGrupo(){
		self.patrullarDerecha()
		game.onTick(16500, "patrullar", {self.cambiarDireccion()})
	}
	method patrullarDerecha(){
		game.onTick(1000,"Movimiento",{self.mover(derecha)})
	}
	method patrullarIzquierda(){
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
	override method disparar(dir){
		const disp = new Disparo(position = self.position().down(1), image = "disparo2.png")
		disp.serDisparadoPor(self, dir)
	}
}


object invasion{
	const property invasores = []
	method enemigoRandom() = 0.randomUpTo(invasores.size()-1)
	method disparoRandom(){
		const enemigoQueDispare = invasores.get(self.enemigoRandom())
		if(invasores.contains(enemigoQueDispare)){
		enemigoQueDispare.disparar(abajo)}
	}
	method atacar(){game.onTick(700, "ataque", {self.disparoRandom()})}
	method detenerAtaque(){game.removeTickEvent("ataque")}
	method colocarFilaDeEnemigos(y){ 
		(1..12).forEach{x => self.aniadir(new Enemigo(position = game.at(x, y), 
			velocidadDeDisparo = 40
		))}

	}
	method aniadir(invasor){invasores.add(invasor)}
	method iniciarGrupo(){
		self.colocarFilaDeEnemigos(18)
		self.colocarFilaDeEnemigos(16)
		self.colocarFilaDeEnemigos(14)
		invasores.forEach({x=>x.iniciar()})
	}
	method estaVacia(){invasores.isEmpty()}
}

class Disparo{
	var property image 
	var property position 
	method puedeMoverA(dir) = dir.puedeMoverse(self)
	method mover(dir){
	if (self.puedeMoverA(dir)){
			dir.moverA(self)
		}else{
			self.detenerDisparo(dir)
		}
	}
	method colocarEn(pos){position = game.at(pos.x(), pos.y())}
	method detenerDisparo(dir){
		game.removeVisual(self)
		game.removeTickEvent("desplazar" + dir)
	}
	method serDisparadoPor(personaje, dir){
		game.addVisual(self)
		game.onTick(personaje.velocidadDeDisparo(), "desplazar" + dir, {self.mover(dir)})
		game.onCollideDo(self, {
		    	x => x.recibirDisparoDe(personaje)
		    	if(not(invasion.invasores().contains(x))or personaje.equals(jugador)){
		    		self.detenerDisparo(dir)
		    	}
		    	
		   })
	}
	method recibirDisparoDe(personaje){}
	
}


object arriba{
	method puedeMoverse(personaje) = personaje.position().y()+1 < game.height()
	method moverA(personaje){
		personaje.position(personaje.position().up(1))
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