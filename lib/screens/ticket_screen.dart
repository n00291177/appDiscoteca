import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../services/consulta_api_service.dart';

class TicketScreen extends StatefulWidget {
  final double total;
  final List<Map<String, dynamic>> pagos;
  final double propina;
  final String mozo;
  final double cambio;

  const TicketScreen({
    super.key,
    required this.total,
    required this.pagos,
    required this.propina,
    required this.mozo,
    required this.cambio,
  });

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final _documentController = TextEditingController();
  String _selectedDocType = 'DNI';
  Map<String, dynamic>? _clientData;

  Future<void> _searchClient() async {
    String numero = _documentController.text.trim();

    if (_selectedDocType == 'DNI') {
      _clientData = await ConsultaApiService.consultarDNI(numero);
      if (_clientData != null) {
        _clientData = {
          'nombre':
          "${_clientData!['nombres']} ${_clientData!['apellidoPaterno']} ${_clientData!['apellidoMaterno']}",
          'documento': numero,
          'tipo': 'DNI',
        };
      }
    } else if (_selectedDocType == 'RUC') {
      _clientData = await ConsultaApiService.consultarRUC(numero);
      if (_clientData != null) {
        _clientData = {
          'nombre': _clientData!['nombre'],
          'documento': numero,
          'tipo': 'RUC',
        };
      }
    }

    setState(() {});
  }

  void _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Ticket de Venta", style: pw.TextStyle(fontSize: 24)),
            if (_clientData != null) ...[
              pw.Text("Cliente: ${_clientData!['nombre']}", style: pw.TextStyle(fontSize: 16)),
              pw.Text("${_clientData!['tipo']}: ${_clientData!['documento']}", style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
            ],
            pw.Text("Total: S/ ${widget.total.toStringAsFixed(2)}"),
            pw.Text("Propina: S/ ${widget.propina.toStringAsFixed(2)}"),
            pw.Text("Mozo: ${widget.mozo}"),
            pw.SizedBox(height: 10),
            pw.Text("Pagos realizados:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ...widget.pagos.map((p) => pw.Text("- ${p['método']}: S/ ${p['monto']}")),
            if (widget.cambio > 0)
              pw.Text("Vuelto: S/ ${widget.cambio.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Ticket de Venta"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        value: _selectedDocType,
                        onChanged: (value) => setState(() => _selectedDocType = value!),
                        items: ['DNI', 'RUC'].map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                      ),
                      TextField(
                        controller: _documentController,
                        decoration: InputDecoration(
                          labelText: 'Número de $_selectedDocType',
                          prefixIcon: const Icon(Icons.badge),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _searchClient,
                        icon: const Icon(Icons.search),
                        label: const Text("Buscar Cliente"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_clientData != null)
                Card(
                  color: Colors.white,
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Colors.deepPurple),
                    title: Text(_clientData!['nombre']),
                    subtitle: Text("${_clientData!['tipo']}: ${_clientData!['documento']}"),
                  ),
                ),
              const SizedBox(height: 16),
              Card(
                color: Colors.white,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Resumen de Venta", style: Theme.of(context).textTheme.titleMedium),
                      const Divider(),
                      Text("Total: S/ ${widget.total.toStringAsFixed(2)}"),
                      Text("Propina: S/ ${widget.propina.toStringAsFixed(2)}"),
                      Text("Mozo: ${widget.mozo}"),
                      const SizedBox(height: 10),
                      const Text("Pagos realizados:", style: TextStyle(fontWeight: FontWeight.bold)),
                      ...widget.pagos.map((p) => Text("- ${p['método']}: S/ ${p['monto']}")),
                      if (widget.cambio > 0)
                        Text("Vuelto entregado: S/ ${widget.cambio.toStringAsFixed(2)}"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _generatePdf,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text("Descargar PDF"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName('/venta'));
                    },
                    icon: const Icon(Icons.exit_to_app),
                    label: const Text("Cerrar y volver"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}