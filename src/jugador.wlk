import wollok.game.*
import main.*

//IDEA: dino come 3 huevos y se hace grande y las instancias de colision matan a los enemigos, tambien cambiar animaciones y velocidad

object dino {
	var posicionActual = game.at(2,1)
	var estaVivo = true
	var comioHuevo = false
	var animacion = "dino1.png"
	
	method image() {return animacion}
	method position() {return posicionActual}
	method estaVivo() {return estaVivo}
//	method morir() {estaVivo = false}
	method iniciar() {
		estaVivo = true
		game.onTick(200,"animarDino",{self.animar()})
	}
	method animar() {
		if (animacion == "dino1.png") {
			animacion = "dino2.png"
		}
		else {
			animacion = "dino1.png"
		}
	}
	method comerHuevo() {
		comioHuevo = true
		game.say(self,"yummy!")
	}
	method saltar() {
		if (estaVivo and posicionActual.y() == 1) {
			self.subir()
			game.schedule(velocidad*3,{self.bajar()})
		}
	}
	method saltoDoble() {
		if (estaVivo and comioHuevo and posicionActual.y() == 1) {
			game.schedule(velocidad,{self.subir()})
			game.schedule(velocidad*2,{self.subir()})
			game.schedule(velocidad*3,{self.bajar()})
			game.schedule(velocidad*5,{self.bajar()})
			comioHuevo = false
		}
	}
	method subir() {posicionActual = posicionActual.up(1)}
	method bajar() {posicionActual = posicionActual.down(1)}
	method detener() {
		estaVivo = false
		game.removeTickEvent("animarDino")
	}
}