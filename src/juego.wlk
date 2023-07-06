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
	var property direccionDeDisparo
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


object jugador inherits Personaje(vidas = 3, position = game.at(5,0), image = "boy.png", velocidadDeDisparo = 80, direccionDeDisparo = arriba){
	var property cantidadDeDisparos = 1
	var property puntosActuales=0
	override method disparar(dir){
		const disp = new Disparo(position = self.position().up(1), image = "mate.png", idDisparo = cantidadDeDisparos)
		if(puedeDisparar){
			disp.serDisparadoPor(self, dir)
			puedeDisparar=false
			game.schedule(1500,{puedeDisparar=true})
			cantidadDeDisparos += 1
		}
	}
	override method recibirDisparoDe(personaje){
		if(vidas == 1) { 
			game.removeVisual(vida)
			self.perderJuego()
		}
		else{
		vidas -= 1.max(0) 
		vida.image("vidas" + vidas + ".png")
		self.restarPuntos(100)
		contador.actualizarPuntos()}
}

	method perderJuego() {
		invasion.detenerAtaque()
		game.removeVisual(self)
		gameOver.ejecutar()
		puedeDisparar=false
	}
	
	override method iniciar(){
		super()
		self.configurarAcciones()
		self.mostrarVidas()
		self.mostrarContador()
	}
	override method mover(dir){
		if (dir.puedeMoverse(self)){
			dir.moverA(self)
		}else{
			position = dir.posDeReinicio()
		}
	}
	method sumarPuntos(cant){
		puntosActuales+=cant
	}
	method restarPuntos(cant){
		if(puntosActuales>100){
			puntosActuales-=100
		}else{
			puntosActuales=0
		}
	}
	method resetear(){
		vidas=3
		puntosActuales=0
	}
	
	method configurarAcciones(){
		keyboard.left().onPressDo{self.mover(izquierda)}
		keyboard.right().onPressDo{self.mover(derecha)}
		keyboard.space().onPressDo{self.disparar(arriba)}
		
	}
	method mostrarVidas(){game.addVisual(vida)}
	method mostrarContador(){game.addVisual(contador)}
}

object vida{
	var property position = game.at(0,19)
	var property image= "vidas3.png"
	method recibirDisparoDe(personaje){}
}

class Enemigo inherits Personaje (vidas = 1, image = "carpincho45.png"){
	var property direccion = derecha
	var property idEnemigo
	var property cantidadDeDisparos = 0
	override method iniciar(){
		super()
		self.moverseEnGrupo()
	}
	override method recibirDisparoDe(personaje){
		if (personaje.equals(jugador)){
			game.removeVisual(self)
			if(invasion.invasores().size()-1 > 0){
				jugador.sumarPuntos(20)
				contador.actualizarPuntos()
			}else{
				invasion.detenerAtaque()
				invasion.invasores().remove(self)
				if(contador.nivel()==1){
					siguienteNivel.ejecutar()
					jugador.resetear()
					contador.nivel(2)
					}else{
						victoria.ejecutar()
					}
			}
		invasion.invasores().remove(self)
		}
	}
	
method moverseEnGrupo(){
		self.patrullar(direccion)
		game.onTick(16500, "patrullar", {self.cambiarDireccion() })
	}
	method patrullar(dir){
		game.onTick(1000,"Movimiento",{self.mover(dir)})
	}

	method cambiarDireccion(){
		self.dejarDeMover()
		abajo.moverA(self)
		direccion= direccion.opuesto()
		self.patrullar(direccion)
	}
	method dejarDeMover(){
		game.removeTickEvent("Movimiento")
	}
	override method disparar(dir){
		const disp = new Disparo(position = self.position().down(1), image = "disparo2.png", idDisparo = "enem" + idEnemigo + cantidadDeDisparos)
		disp.serDisparadoPor(self, dir)
		cantidadDeDisparos += 1
	}
}
object contador{
	var property text= "PUNTOS: " + jugador.puntosActuales().toString()
	var property position=game.at(26,18)
	var property textColor= "#000000"
	var property nivel=1
	method actualizarPuntos(){
		text= "PUNTOS: " + jugador.puntosActuales().toString()
	}
	method recibirDisparoDe(personaje){}
}


object invasion{
	const property invasores = []
	method enemigoRandom() = 0.randomUpTo(invasores.size()-1)
	method disparoRandom(){
		const enemigoQueDispare = invasores.get(self.enemigoRandom())
		if(invasores.contains(enemigoQueDispare)){
		enemigoQueDispare.disparar(abajo)}
	}
	method atacar(){game.onTick(1200, "ataque", {self.disparoRandom()})}
	method detenerAtaque(){game.removeTickEvent("ataque")}
	method colocarFilaDeEnemigos(y){ 
		(1..12).forEach{x => self.aniadir(new Enemigo(position = game.at(x, y), 
			velocidadDeDisparo = 40,
			direccionDeDisparo = abajo, 
			idEnemigo = (x+y)
		))}

	}
	method aniadir(invasor){invasores.add(invasor)}
	method iniciarGrupo(){
		self.colocarFilaDeEnemigos(17)
		self.colocarFilaDeEnemigos(15)
		self.colocarFilaDeEnemigos(13)
		invasores.forEach({x=>x.iniciar()})
	}
	method estaVacia() = invasores.isEmpty()
}

class Disparo{
	var property image 
	var property position 
	var property idDisparo
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
		game.removeTickEvent("desplazar" + dir + idDisparo)
	}
	method serDisparadoPor(personaje, dir){
		game.addVisual(self)
		game.onTick(personaje.velocidadDeDisparo(), "desplazar" + dir + idDisparo, {self.mover(dir)})
		game.onCollideDo(self, {
		    	x => if(not(invasion.invasores().contains(x))or personaje.equals(jugador)){
		    		x.recibirDisparoDe(personaje)
		    		self.detenerDisparo(dir)
		    	}else{
		    		x.recibirDisparoDe(personaje)
		    	}
		    	
		   })
	}
	method recibirDisparoDe(personaje){
		self.detenerDisparo(personaje.direccionDeDisparo().opuesto())
	}
	
}


object arriba{
	method puedeMoverse(personaje) = personaje.position().y()+1 < game.height()
	method moverA(personaje){
		personaje.position(personaje.position().up(1))
	}
	method opuesto() = abajo
}

object abajo{
	method puedeMoverse(personaje) = personaje.position().y()-1 > -1
	method moverA(personaje){
		personaje.position( personaje.position().down(1))
	}
	method opuesto() = arriba
}

object derecha{
	method posDeReinicio() = game.at(0,0)
	method puedeMoverse(personaje) = personaje.position().x()+1 < game.width()
	method moverA(personaje){
		personaje.position( personaje.position().right(1))
	}
	method opuesto() = izquierda
}

object izquierda{
	method posDeReinicio() = game.at(game.width()-1,0)
	method puedeMoverse(personaje) = personaje.position().x()-1 > -1
	method moverA(personaje){
		personaje.position( personaje.position().left(1))
	}
	method opuesto() = derecha
}