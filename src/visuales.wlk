import wollok.game.*
import config.*
import juego.*
import niveles.*
import portadas.*

class Obstaculos{
	const property obstaculos = []
	var property vidas
	var property image = "arbusto.png"
	var property position = 0
	
	method iniciar(){
		//self.aniadirGrupo(2,3)
		
		game.onCollideDo(self, {x => 
			x.detenerDisparo()
			x.detenerDisparoEnemigo()
		})
	}
	method aniadirGrupo(uno,dos){
		const grupo1 = new Obstaculos(position = game.at(uno, 3), vidas = vidas)
		const grupo2 = new Obstaculos(position = game.at(dos, 3), vidas = vidas)
		game.addVisual(grupo1)
		game.addVisual(grupo2)
		grupo1.iniciar()
		grupo2.iniciar()
	}
	method recibirDisparo(){
		if(vidas == 1){
			game.removeVisual(self)
		}else{
			vidas -= 1
			self.atacar()			
		}		
	}
	method recibirDisparoEnemigo(){
		if(vidas == 1){
			game.removeVisual(self)
		}else{
			vidas -= 1
			self.atacar()			
		}		
	}

	method atacar(){
		var cont = 0
		if (vidas%3 == 0){
			cont += 1
			image = "arbusto" + cont + ".png"
		}
	}
}

class GrupoArbustos inherits Obstaculos{
	override method iniciar(){
		self.aniadirGrupo(2,3)
		self.aniadirGrupo(8,9)
		self.aniadirGrupo(14,15)
		self.aniadirGrupo(20,21)
		self.aniadirGrupo(26,27)
		
	}	
}

