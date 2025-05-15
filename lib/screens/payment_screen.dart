import 'package:flutter/material.dart';
import 'package:nina_app/screens/ticket_screen.dart';

class PaymentScreen  extends StatefulWidget {
  final double totalAmount;
  final String waiterName;

  const PaymentScreen({Key? key, required this.totalAmount, required this.waiterName}) : super(key: key);

  @override
  _PaymentScreenState  createState() => _PaymentScreenState ();
}

class _PaymentScreenState  extends State<PaymentScreen> {
  String _selectedMethod = "Efectivo";
  final List<String> _methods = ["Efectivo", "Yape", "Transferencia", "Tarjeta"];
  final List<Map<String, dynamic>> _paymentDetails = [];
  final TextEditingController _paymentController = TextEditingController();
  double _totalPaid = 0.0;
  double _tip = 0.0;
  double _change = 0.0;

  void _addPayment() {
    final amount = double.tryParse(_paymentController.text);
    if (amount == null || amount <= 0) return;

    setState(() {
      _paymentDetails.add({"método": _selectedMethod, "monto": amount});
      _totalPaid += amount;
      double remaining = widget.totalAmount - _totalPaid;
      if (remaining < 0) {
        _change = -remaining;
      } else {
        _change = 0.0;
      }
      _paymentController.clear();
    });
  }

  void _finishSale() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Venta Completada"),
        content: Text("Total: S/ ${widget.totalAmount.toStringAsFixed(2)}\n"
            "Propina: S/ ${_tip.toStringAsFixed(2)}\n"
            "Pagado: S/ ${_totalPaid.toStringAsFixed(2)}\n"
            "Vuelto: S/ ${_change.toStringAsFixed(2)}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
  void _finishSale2() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketScreen(
          total: widget.totalAmount,
          pagos: _paymentDetails,
          propina: _tip,
          mozo: widget.waiterName,
          cambio: _change,
        ),
      ),
    );
  }

  void _simulatePrintTicket() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Simulando impresión del ticket...")),
    );
  }

  void _goToMainMenu() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = (widget.totalAmount - _totalPaid).clamp(0, double.infinity);

    return Scaffold(
      appBar: AppBar(title: const Text("Cobro del Pedido"), centerTitle: true),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      color: Colors.orange[50],
                      child: ListTile(
                        leading: const Icon(Icons.attach_money, color: Colors.green),
                        title: Text("Total a pagar: S/ ${widget.totalAmount.toStringAsFixed(2)}"),
                        subtitle: Text("Restante: S/ ${remaining.toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.red)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedMethod,
                            items: _methods.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                            onChanged: (val) => setState(() => _selectedMethod = val!),
                            decoration: const InputDecoration(labelText: "Método de pago", border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _paymentController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Monto', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _addPayment,
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text("Agregar pago"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    ),
                    const Divider(),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Propina (opcional)', border: OutlineInputBorder()),
                      onChanged: (val) => setState(() => _tip = double.tryParse(val) ?? 0),
                    ),
                    const SizedBox(height: 12),
                    const Text("Pagos registrados", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    ..._paymentDetails.map((p) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.payment),
                        title: Text("${p['método']}"),
                        trailing: Text("S/ ${p['monto']}"),
                      ),
                    )),
                    if (_change > 0)
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text("Vuelto: S/ ${_change.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 16, color: Colors.green)),
                      ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: remaining <= 0 ? _finishSale : null,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text("Culminar Venta"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: remaining <= 0 ? _finishSale2 : null,
                      icon: const Icon(Icons.print),
                      label: const Text("Imprimir Boleta / Factura"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _goToMainMenu,
                      icon: const Icon(Icons.home),
                      label: const Text("Volver al menú principal"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}