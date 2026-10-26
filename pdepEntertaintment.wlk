
class Entrada {
  const banda
  const fechaConcierto
  var precio = 1000 //precio base sin impuesto 

  method precioConDescuento() {
    precio = precio+productora.impuesto 
  }
}
  

class Asistente {
  var tipoDeAbono = fan //inicializo
  var historialDeEntradas = [] //(inicialmente no tiene ninguna)
  var saldo // puede ser negativo

  method puedeComprarEntrada() {
      return saldo > 0
  } 

  method comprarEntrada(banda , fecha) {
    if (self.puedeComprarEntrada()) {
      const entrada = new Entrada(banda = banda, fechaConcierto = fecha) //agrego a historial
      const monto = entrada.precioConDescuento(tipoDeAbono.porcentajeDescuento)
      saldo -= monto 
      historialDeEntradas.add(entrada)
    } else {
      self.error("No se puede comprar una entrada con saldo no positivo")
    }
  }  
  //uso esta manera de tirar el error porque no tengo ningun otro tipo de excepcion como para 
  //programar una clase de excepciones personalizadas. para que usar la herencia si es solo UN error?
  
  method entradasAnteriores(historialDeEntradas){
    const hoy = new Date()
    const anioPasado = hoy.year() - 1
    
    return historialDeEntradas.filter({entrada => entrada.fecha.year() == anioPasado})
  }

  method nombreBandasCompradas(historialDeEntradas){
    return historialDeEntradas.map({entrada => entrada.nombre()}).asSet()
  }
}

object fan {
  const porcentajeDescuento = 0
}

object vip {
  var porcentajeDescuento 
}


//utilizo herencia en la banda porque comparten ciertos metodos que se repiten, asi que me evito repetir
//logica con cada tipo de banda que tengo.
class Banda {
  const nombre 
  const canon = 1000000 //canon base, solo cambia en trap
  var gastoExtra

  method presupuesto() {
    return canon + gastoExtra
  }

  method popularidad()
  //uso una clase abstracta que defino en cada subclase ya que segun el tipo de banda, su 
  //popularidad no es la misma, asi que lo delego para escribirlo a detalle en cada banda.

}


class BandaDeRock inherits Banda (gastoExtra=10000) {
  var cantidadSolosGuitarra

  override method popularidad(){
    return cantidadSolosGuitarra*100
  }
}

class BandaDeTrap inherits Banda (gastoExtra=0){
  const tienenHielo = false //inicializo así por ahora

  override method popularidad(){
    if(tienenHielo){
      return 1000
    } else {return 0}
  }
}

class BandaIndie inherits Banda {
  const cantInstrumentos

  method cuantoGastoExtra(cantInstrumentos){
    return cantInstrumentos*500
  }
  
  override method popularidad(){
    return nombre.size()*3,14
  }
  
}


object productora {
  var impuesto //para ponerlo en las entradas 
  var asistente

  method gananciaTotal() {
    return historialDeEntradas.map({entrada => entrada.precio}).sum()
  }

  method cantEntradasVendidas() { // recaudación de las entradas compradas por los asistentes
    return historialDeEntradas.length()
  }

  method bandaMasPopular() {
    const mejorBanda = historialDeEntradas.map({entrada => entrada.banda.popularidad}).max()
  }

  method bonificarAsistentes() { // debe poder bonificar a los asistentes vip

  } 


}
