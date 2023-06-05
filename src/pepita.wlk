import wollok.game.*
object spaceInvaders {
  const property enemies= []
  const property bullets= []
  

  method setup() {
   const enemy1= new Enemies(x=0,y=10)
    enemies.add(enemy1)
    game.addVisual(player)
    game.addVisual(enemies)
	game.width(11)
	game.height(11)
	game.cellSize(32)
	keyboard.left().onPressDo{player.moveteIzquierda()}
	keyboard.right().onPressDo{player.moveteDerecha()}
	keyboard.space().onPressDo{bala.disparar()}
  }
}
object player {
	var property x = 5
	var property y = 0
	var property position = game.at(x,y)
	var property image = "img/nave.png"
	method moveteDerecha(){
		x=x+1
		position = game.at(x,y)
	}
	
	method moveteIzquierda(){
		x=x-1
		position = game.at(x,y)
	}
	
	method disparar(){
		bala.disparar()
	}
	
}
object bala {
	var property position = game.at(player.x(),player.y()+1)
	var property image
	method disparar(){
		image= "img/bala.png"
		game.whenCollideDo(spaceInvaders.enemies(),{self.desaparecer()})
	}
	method moverArriba(){
	 self.position(self.position().up(1))
	}
	method moverAbajo(){
	 self.position(self.position().down(1))
	}
	method desaparecer(){
		game.removeVisual(self)
	}
}
class Enemies{
	var property x
	var property y 
	var property position = game.at(x,y)
		var property image= "img/bichito11.png"
	method moveteDerecha(){
		x=x+1
		position = game.at(x,y)
	}
	
	method moveteIzquierda(){
		x=x-1
		position = game.at(x,y)
	}
	method mover(){
		game.onTick(2000,"Enemy1",{self.moveteDerecha()})
	}
	method desaparecer(){
		image="img/bichito12.png"
		game.removeVisual(self)
		
	}
}
class Bloque{
	var property position
	var property image= "img/bichito11.png"
}
