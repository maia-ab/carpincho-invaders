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


object jugador inherits Personaje(vidas = 3, position = game.at(5,0), image = "boy.png"){
	var property cantidadDeDisparos = 1
	var property puntosActuales=0
	var property nivelActual = 0
	override method disparar(dir){
		const disp = new DisparoJugador(position = self.position().up(1), idDisparo = cantidadDeDisparos)
		if(puedeDisparar){
			disp.serDisparado()
			puedeDisparar=false
			game.schedule(1500,{puedeDisparar=true})
			cantidadDeDisparos += 1
		}
	}
	method recibirDisparo(){}
	method recibirDisparoEnemigo(){
		if(vidas == 1) { 
			game.removeVisual(grupoVidas)
			self.perderJuego()
		}
		else{
		vidas -= 1.max(0) 
		grupoVidas.image("vidas" + vidas + ".png")
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
		self.mostrarContador()
		game.onCollideDo(self, {x => x.detenerDisparo()})
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
		puntosActuales = 0.max(puntosActuales - cant)
	}
	
	method configurarAcciones(){
		keyboard.left().onPressDo{self.mover(izquierda)}
		keyboard.right().onPressDo{self.mover(derecha)}
		keyboard.space().onPressDo{self.disparar(arriba)}
		
	}
	method pasarNivel(){
		nivelActual.pasarNivel()
	    nivelActual = nivelActual.siguiente()
		vidas = 3		
	}
	method mostrarContador(){game.addVisual(contador)}
}


class Enemigo inherits Personaje (vidas = 1, image = "carpincho45.png"){
	var property direccion = derecha
	var property idEnemigo
	var property cantidadDeDisparos = 0
	override method iniciar(){
		super()
		self.moverseEnGrupo()
		game.onCollideDo(self, {x => x.recibirDisparoEnemigo()
			
		})
	}
	method recibirDisparo(){
		jugador.sumarPuntos(20)
		contador.actualizarPuntos()
		invasion.eliminarInvasor(self)
		game.removeVisual(self)
	}
	method recibirDisparoEnemigo(){}

	
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
		const dispEn = new DisparoEnemigo(position = self.position().down(1), idDisparo = "enem" + idEnemigo + cantidadDeDisparos)
		dispEn.serDisparado()
		cantidadDeDisparos += 1
	}
}



object invasion{
	const property invasores = []
	method disparoRandom(){
		invasores.anyOne().disparar(abajo)
	}
	
	method atacar(){game.onTick(1200, "ataque", {self.disparoRandom()})}
	method detenerAtaque(){game.removeTickEvent("ataque")}
	method colocarFilaDeEnemigos(y){ 
		(1..12).forEach{x => self.aniadir(new Enemigo(position = game.at(x, y), idEnemigo = (x+y)))}
	}
	method aniadir(invasor){invasores.add(invasor)}
	method iniciarGrupo(){
		self.colocarFilaDeEnemigos(17)
		self.colocarFilaDeEnemigos(15)
		self.colocarFilaDeEnemigos(13)
		invasores.forEach({x=>x.iniciar()})
	}
	method eliminarInvasor(invasor){
		if (invasores.size()-1 > 0){
			invasores.remove(invasor)		
		}else{
			invasores.clear()
			self.detenerAtaque()
			jugador.pasarNivel()			
		}
	}
	
}

//VIDAS
object grupoVidas{
	var property position = game.at(0,19)
	var property image = "vidas" + jugador.vidas() + ".png"
	method recibirDisparoDe(personaje){}
	method iniciar(){game.addVisual(self)}
	method resetear(){image = "vidas3.png"}
}

//CONTADOR
object contador{
	var property text= "PUNTOS: " + jugador.puntosActuales().toString()
	var property position=game.at(26,18)
	var property textColor= "#FFFFFF"
	method actualizarPuntos(){
		text= "PUNTOS: " + jugador.puntosActuales().toString()
	}
	method resetear(){
		jugador.puntosActuales(0)
		self.actualizarPuntos()
	}
	method recibirDisparoDe(personaje){}
}

//DISPAROS
class Disparo{
	var property image 
	var property position 
	var property idDisparo
	var property direccion
	var property velocidad
	method puedeMoverA(dir) = dir.puedeMoverse(self)
	method mover(dir)
	method detenerDisparo(){}
	method detenerDisparoEnemigo(){}
	method recibirDisparo(){}
	method recibirDisparoEnemigo(){}
	method serDisparado(){
		game.addVisual(self)
		game.onTick(velocidad, "desplazar" + direccion + idDisparo, {self.mover(direccion)})		
	}
}

class DisparoJugador inherits Disparo(image = "mate.png", direccion = arriba, velocidad = 80){
	override method mover(dir){
		if (self.puedeMoverA(dir)){
			dir.moverA(self)
		}else{
			self.detenerDisparo()
		}		
	}
	override method serDisparado(){
	    super()
		game.onCollideDo(self, {x => x.recibirDisparo()
			self.detenerDisparo()   
		})
	}
	override method detenerDisparo(){
		game.removeVisual(self)
		game.removeTickEvent("desplazar" + direccion + idDisparo)
	}
	
}

class DisparoEnemigo inherits Disparo(image = "disparo2.png", direccion = abajo, velocidad = 20){
	override method mover(dir){
		if (self.puedeMoverA(dir)){
			dir.moverA(self)
		}else{
			self.detenerDisparoEnemigo()
		}		
	}
	override method serDisparado(){
		super()
		game.onCollideDo(self, {x => x.recibirDisparoEnemigo()})
	}
	override method recibirDisparo(){
		self.detenerDisparo()
	}
	override method detenerDisparoEnemigo(){
		game.removeVisual(self)
		game.removeTickEvent("desplazar" + direccion + idDisparo)
		
	} 
	
	
}


//DIRECCIONES

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