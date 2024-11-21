class FormaDePago {
    method puedePagar(monto) {
        throw new Exception(message = "No puede pagar")
    }

    method realizarPago(monto) {
        throw new Exception(message = "No se realizo el pago")
    }
    
    method totalCuotasVencidas() = 0

    method pagarCuotas(dineroDisponible) 
        = dineroDisponible
    

// para el pagador compulsivo
    method pagarCuotasRestantesConEfectivo(dineroDisponible) 
        = null 
    
}

class Efectivo inherits FormaDePago {
  var saldoDisponible = 0

    method inicializarSaldo(saldo) {
        saldoDisponible = saldo
    }

    override method puedePagar(monto) =
     saldoDisponible >= monto
    

    override method realizarPago(monto) {
        if (saldoDisponible >= monto) {
            saldoDisponible -= monto
        }
    }


override method pagarCuotas(dineroDisponible) {
    const montoPagado = dineroDisponible.min(saldoDisponible)
    saldoDisponible -= montoPagado
    return dineroDisponible - montoPagado
}

    override method pagarCuotasRestantesConEfectivo(dineroDisponible) = self.pagarCuotas(dineroDisponible)
    



}

class Debito inherits FormaDePago {
    var cuentaBancaria = null

    method asociarCuenta(cuenta) {
        cuentaBancaria = cuenta
    }

    override method puedePagar(monto) 
        = CuentaBancaria.saldo >= monto
    

    override method realizarPago(monto) {
        if (CuentaBancaria.saldo >= monto) {
            cuentaBancaria.debitar(monto)
        }
    }
}

class CuentaBancaria {
    var saldo = 0

    method inicializarSaldo(saldoInicial) {
        saldo = saldoInicial
    }

    method debitar(monto) {
        if (saldo >= monto) {
            saldo -= monto
        } else {
            throw new Exception(message = "Saldo insuficiente en la cuenta bancaria")
        }
    }
}

class Credito inherits FormaDePago {
    var limite = 0
    var tasaInteres = 0
    var cuotasPendientes = []

    method configurarCredito(limiteCredito, tasa) {
        limite = limiteCredito
        tasaInteres = tasa
    }

    override method puedePagar(monto) =
         monto <= limite
    

override method realizarPago(monto) {
        if (monto <= limite) {
            const cuotas = 3 // Para simplificar
            const cuotaMensual = monto * (1 + tasaInteres) / cuotas
            cuotasPendientes.add(cuotaMensual)
        }
    }
override method totalCuotasVencidas() 
        = cuotasPendientes.sum()
    

override method pagarCuotas(dineroDisponible) {
    var saldoRestante = dineroDisponible
        cuotasPendientes.filter({ cuota => saldoRestante >= cuota }).forEach({ cuota =>
            saldoRestante -= cuota
            cuotasPendientes.remove(cuota)
        })
        return saldoRestante
    }
                      


}

//forma de pago inventada
class CreditoDiferido inherits Credito {
    var comprasDiferidas = []

    override method realizarPago(monto) {
        if (monto <= limite) {
            comprasDiferidas.add(monto)
        }
    }

    method generarCuotas() {
        comprasDiferidas.forEach({ monto =>
            const cuotas = 3 // Para simplificar
            const cuotaMensual = monto * (1 + tasaInteres) / cuotas
            cuotasPendientes.add(cuotaMensual)
        })
        comprasDiferidas.clear() // Vaciar compras diferidas una vez que se convierten en cuotas
    }
}




