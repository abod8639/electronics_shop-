import 'package:flutter/material.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/order/data/models/order_model.dart';

class OrderStatusTimeline extends StatelessWidget {
  final OrderModel order;
  const OrderStatusTimeline({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildStatusPulse(order.status),
            const SizedBox(width: 12),
            Text(
              'CURRENT_STATUS: ${order.status.toUpperCase()}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildPipelineStep('INITIALIZED', true),
        _buildPipelineDivider(true),
        _buildPipelineStep('PROCESSING', order.status != 'pending'),
        _buildPipelineDivider(order.status != 'pending'),
        _buildPipelineStep('DISPATCHED', order.status == 'shipped' || order.status == 'delivered'),
        _buildPipelineDivider(order.status == 'shipped' || order.status == 'delivered'),
        _buildPipelineStep('COMPLETED', order.status == 'delivered'),
      ],
    );
  }

  Widget _buildStatusPulse(String status) {
    Color color = Colors.amber;
    if (status == 'delivered') color = AppColors.cyan;
    if (status == 'cancelled') color = AppColors.error;

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineStep(String label, bool isCompleted) {
    return Row(
      children: [
        Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 16,
          color: isCompleted ? AppColors.cyan : Colors.white24,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: isCompleted ? Colors.white : Colors.white24,
            fontSize: 12,
            fontFamily: 'monospace',
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildPipelineDivider(bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(left: 7, top: 4, bottom: 4),
      width: 2,
      height: 20,
      color: isCompleted ? AppColors.cyan.withValues(alpha: 0.3) : Colors.white10,
    );
  }
}
