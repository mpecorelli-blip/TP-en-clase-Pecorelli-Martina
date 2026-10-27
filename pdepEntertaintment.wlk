class Entrada {
  const property banda 
// uso el property ya que permite generar automáticamente los métodos de acceso
  const property fechaConcierto
  const precioBase = 1000

  method precioConImpuesto() = precioBase + productora.impuesto()

// Separo el calculo del precio con impuesto del descuento,
// para reutilizar el resultado y evitar repetir logica.
  method precioConDescuento(porcentaje){
    self.precioConImpuesto() * (1 - porcentaje / 100)
  }
}

class Asistente {
  var property tipoDeAbono = fan // inicializo, despues puede cambiar
  var historialDeEntradas = [] 
// inicialmente la lista no tiene nada, la declaro vacia
  var saldo 


  method puedeComprarEntrada() {
      return saldo > 0
  } // puede ser negativo asi que me hago un auxiliar que lo corrobore

  method comprarEntrada(banda , fecha) {
    if (self.puedeComprarEntrada()) {
  //Con self, puedo hacer que el objeto se conozca a si mismo
      const entrada = new Entrada(banda = banda, fechaConcierto = fecha) 
      saldo -= entrada.precioConDescuento(tipoDeAbono.porcentajeDescuento()) 
      historialDeEntradas.add(entrada) //agrega a la lista del historial
    } else {
      self.error("No se puede comprar una entrada con saldo no positivo")
    }
  }  
  //uso esta manera de tirar el error porque no tengo ningun otro tipo de excepcion como para 
  //programar una clase de excepciones personalizadas. para que usar la herencia si es solo UN error?
  
  method entradasAnteriores(){
    const hoy = new Date() //clase de fechas, separado por dia mes y anio
    const anioPasado = hoy.year() - 1
    
    return historialDeEntradas.filter({entrada => entrada.fechaConcierto.year() == anioPasado})
  }

  method nombreBandasCompradas(){
    return historialDeEntradas.map({entrada => banda.nombre()}).asSet()
  }
}

object fan {
  method porcentajeDescuento() = 0
}

class Vip {
  var porcentajeDescuento

  method porcentajeDescuento() = porcentajeDescuento

  method bonificar() { 
    porcentajeDescuento += 1 
    }
}
//uso una clase para vip porque tengo un descuento de cada asistente


class Banda {
  const property nombre
  const canon = 1000000
  var gastoExtra

  method presupuesto() {
    return canon + gastoExtra
  }

  method popularidad()
// uso las clases abstractas cuando despues quiero declarar diferentes utilidades
// tengo polimorfismo-> se puede pedir popularidad() a cualquier banda 
}

// uso la herencia porque tengo varias bandas que comparten ciertas caracteristicas aunque despues segun
// el tipo de banda tenga algunas caracteristicas especiales

class BandaDeRock inherits Banda (gastoExtra = 10000) {
  var cantidadSolosGuitarra

//redefino el metodo heredado para concordar con la condicion de las bandas de rock por ejemplo
  override method popularidad() {
    return cantidadSolosGuitarra * 100
  }
}

class BandaDeTrap inherits Banda (gastoExtra = 0) {
  var tienenHielo

  override method popularidad() {
    if (tienenHielo) {
      return 1000
    } else {
      return 0
    }
  }

  override method presupuesto() {
    return self.popularidad() * 1000000 + gastoExtra
  }
}

class BandaIndie inherits Banda {
  var cantInstrumentos

  override method presupuesto() {
    return canon + cantInstrumentos * 500
  }

  override method popularidad() {
    return nombre.size() * 3.14
  }
}

object productora {
  var impuesto 
// para ponerlo en las entradas, no se cuanto es
  const asistentes = []
  const bandas = []
// estas listas me quedan que la productora pueda conocer los otros objetos

  method gananciaTotal() {
    return historialDeEntradas.map({entrada => entrada.precio}).sum()
  }

  method cantEntradasVendidas() { 
    return asistentes.historialDeEntradas.length()
  }

  method bandaMasPopular() {
    bandas.max({b => self.entradasVendidas().count({e => e.banda() == b})})
  }

  method bonificarAsistentesVip() {
    asistentes.filter({a => a.esVip()}).forEach({a => a.tipoDeAbono().bonificar()})
  }
}
