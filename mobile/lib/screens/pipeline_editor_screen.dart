import 'package:flutter/material.dart';

import '../constants/palette.dart';
import '../constants/shadows.dart';
import '../models/models.dart';
import '../widgets/canvas/connection_painter.dart';
import '../widgets/canvas/grid_painter.dart';
import '../widgets/node_picker.dart';
import '../widgets/pipeline_node_widget.dart';

class PipelineEditorScreen extends StatefulWidget {
  const PipelineEditorScreen({super.key});

  @override
  State<PipelineEditorScreen> createState() => _PipelineEditorScreenState();
}

class _PipelineEditorScreenState extends State<PipelineEditorScreen> {
  final List<PipelineNode> _nodes = [
    PipelineNode(
      id: 1,
      type: NodeType.action,
      service: services['github']!,
      title: 'New Issue',
      description: 'Triggers on new issues',
      position: const Offset(40, 160),
    ),
    PipelineNode(
      id: 2,
      type: NodeType.reaction,
      service: services['discord']!,
      title: 'Send Message',
      description: 'Posts to #alerts',
      position: const Offset(260, 160),
    ),
  ];

  final List<NodeConnection> _connections = [const NodeConnection(1, 2)];
  int? _selectedNodeId;
  int? _connectingFrom;
  String _areaName = 'New Automation';

  void _onNodePan(int id, Offset delta) {
    setState(() {
      final idx = _nodes.indexWhere((node) => node.id == id);
      if (idx == -1) return;
      final node = _nodes[idx];
      _nodes[idx] = node.copyWith(position: node.position + delta);
    });
  }

  void _onDelete(int id) {
    setState(() {
      _nodes.removeWhere((node) => node.id == id);
      _connections.removeWhere((conn) => conn.from == id || conn.to == id);
      if (_selectedNodeId == id) {
        _selectedNodeId = null;
      }
    });
  }

  Future<void> _addNode(NodeType type) async {
    final template = await showModalBottomSheet<NodeTemplate>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => NodePicker(type: type),
    );

    if (template == null) return;

    setState(() {
      final newId = DateTime.now().millisecondsSinceEpoch;
      final baseX = type == NodeType.action ? 40.0 : 260.0;
      _nodes.add(
        PipelineNode(
          id: newId,
          type: type,
          service: services[template.serviceId]!,
          title: template.name,
          description: template.description,
          position: Offset(baseX, 280 + _nodes.length * 40),
        ),
      );
    });
  }

  void _startConnection(int id) {
    setState(() => _connectingFrom = id);
  }

  void _finishConnection(int id) {
    if (_connectingFrom == null || _connectingFrom == id) {
      setState(() => _connectingFrom = null);
      return;
    }

    final exists = _connections.any((conn) => conn.from == _connectingFrom && conn.to == id);
    if (!exists) {
      setState(() {
        _connections.add(NodeConnection(_connectingFrom!, id));
        _connectingFrom = null;
      });
    } else {
      setState(() => _connectingFrom = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(color: AppPalette.dark, boxShadow: AppShadows.appBar),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: _areaName),
                  onChanged: (value) => _areaName = value,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Name your AREA',
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: () => _addNode(NodeType.action),
                style: FilledButton.styleFrom(backgroundColor: AppPalette.nodeAction, foregroundColor: Colors.white),
                icon: const Icon(Icons.add),
                label: const Text('Action'),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () => _addNode(NodeType.reaction),
                style: FilledButton.styleFrom(backgroundColor: AppPalette.nodeReaction, foregroundColor: Colors.white),
                icon: const Icon(Icons.add),
                label: const Text('Reaction'),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: AppPalette.canvas,
            child: Stack(
              children: [
                Positioned.fill(child: CustomPaint(painter: GridPainter())),
                Positioned.fill(
                  child: CustomPaint(
                    painter: ConnectionPainter(nodes: _nodes, connections: _connections),
                  ),
                ),
                ..._nodes.map(
                  (node) => PipelineNodeWidget(
                    key: ValueKey(node.id),
                    node: node,
                    isSelected: node.id == _selectedNodeId,
                    isConnectingFrom: node.id == _connectingFrom,
                    onTap: () => setState(() => _selectedNodeId = node.id),
                    onPanUpdate: (delta) => _onNodePan(node.id, delta),
                    onDelete: () => _onDelete(node.id),
                    onConnectorTap: () {
                      if (node.type == NodeType.action) {
                        _startConnection(node.id);
                      } else {
                        _finishConnection(node.id);
                      }
                    },
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Drag nodes to reorder • Tap connectors to link',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

