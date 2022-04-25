import wollok.game.*
import jugadorYPersonajes.*

const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(6)
		game.title("Dinosaur Game")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
		game.addVisual(dinoCuelloLargo)
		game.addVisual(dinoVolador)
		keyboard.space().onPressDo{ self.jugar()}
		game.onCollideDo(dino,{objeto => objeto.efectoDeColisionar()})
	}
	
	method iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
		dinoCuelloLargo.iniciar()
		dinoVolador.iniciar()
	}
	
	method jugar(){
		if (dino.activo())
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			game.removeVisual(marcador)
			self.iniciar()
		}
	}
	
	method terminar(){
		game.removeTickEvent("moverCactus")
		game.removeTickEvent("moverDinoCuelloLargo")
		game.removeTickEvent("moverDinoVolador")
		game.removeTickEvent("tiempo")
		marcador.comprobarTiempo(reloj.tiempoLogrado())
		game.addVisual(gameOver)
		game.addVisual(marcador)
		dino.detener()
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
	

}

object reloj {
	
	var tiempo = 0
	
	method text() = "Tiempo:" + tiempo.toString()
	method position() = game.at(game.width()/2, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo +1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method tiempoLogrado(){
		return tiempo
	}
}

object marcador {
	
	var mejorTiempo = 0
	
	method text() = "Mejor tiempo: " + mejorTiempo.toString()
	method position() = game.at(game.width()/2, game.height()-2)
	
	method comprobarTiempo(ultimoTiempo) {
		if (ultimoTiempo > mejorTiempo) {
			mejorTiempo = ultimoTiempo
		}
	}
}

object suelo{
	
	method position() = game.origin().up(1)
	method image() = "suelo.png"
}