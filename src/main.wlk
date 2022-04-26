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
		keyboard.enter().onPressDo{self.jugar()}
		keyboard.space().onPressDo{dino.saltar()}
		keyboard.alt().onPressDo{dino.dobleSalto()}
		game.onCollideDo(dino,{objeto => objeto.efectoDeColisionar()})
	}
	method iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
		game.schedule(velocidad*10,{dinoVolador.iniciar()})
		game.schedule(velocidad*50,{dinoCuelloLargo.iniciar()})
	}
	method jugar(){
		if (not dino.activo()) {
			game.removeVisual(gameOver)
			game.removeVisual(marcador)
			self.iniciar()
		}
	}
	method terminar(){
		cactus.terminar()
		dinoCuelloLargo.terminar()
		dinoVolador.terminar()
		game.removeTickEvent("cambiarPasoDino")
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
	method tiempo() {
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