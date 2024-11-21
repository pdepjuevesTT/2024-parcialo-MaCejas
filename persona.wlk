class Persona {
    var property formasDePago = []
    var property formaPreferida
    var property objetosAdquiridos = []
    var property sueldo
    var property dinero
    var nombre
    var property compras = []


method configurarPersona(nombrePersona, sueldoBase) {
        nombre = nombrePersona
        sueldo = sueldoBase
        dinero = 0
    }

method agregarFormaDePago(formaDePago) {
        formasDePago.add(formaDePago)
    }

method establecerFormaPreferida(forma) {
        if (formasDePago.contains(forma)) 
            formaPreferida = forma
}



method realizarCompra(monto) {
        if (formaPreferida.puedePagar(self, monto)) {
            formaPreferida.realizarPago(self, monto)
            compras.add(monto)
        }
}

 method reducirDinero(persona, monto) {
        dinero -= monto
    }

    method aumentarDinero(persona, monto) {
        dinero += monto
    }

    method mes() {
        dinero += sueldo
        formasDePago.forEach({ forma => forma.pagarCuotas(self) })
    
    }

    method totalCuotasVencidas() 
        = formasDePago.map({ forma => forma.totalCuotasVencidas() }).sum()
    
}

object personaQueMasPosee {
    method personaConMasCompras(personas) {
        var personaConMas = personas.first()
        
        personas.forEach({ persona =>
            if (persona.compras().size() > personaConMas.compras().size()) {
                personaConMas = persona
            }
        })

        return personaConMas
    }
}


class CompradorCompulsivo inherits Persona {
 override method realizarCompra(monto) {
        formasDePago.find({ forma => forma.puedePagar(monto) }).
        forEach({ forma => forma.realizarPago(monto) compras.add(monto)})
    }
}



class PagadorCompulsivo inherits Persona {
    override method mes() {
        dinero += sueldo

        // Intentar pagar cuotas pendientes con las formas de pago disponibles
        formasDePago.forEach({ forma =>
            dinero = forma.pagarCuotas(dinero)
        })

        // Usar efectivo para cubrir cualquier deuda restante
        formasDePago.forEach({ forma =>
            const nuevoDinero = forma.pagarCuotasRestantesConEfectivo(dinero)
            if (nuevoDinero != null) {
                dinero = nuevoDinero
            }
        })
    }
}