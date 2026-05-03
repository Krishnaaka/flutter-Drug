package com.discts.service;

import com.discts.model.DrugOrder;
import com.discts.model.OrderStatus;
import com.discts.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;

    public List<DrugOrder> getAllOrders() {
        return orderRepository.findAll();
    }

    public List<DrugOrder> getOrdersByHospital(Long hospitalId) {
        return orderRepository.findByHospitalId(hospitalId);
    }

    public List<DrugOrder> getOrdersByVendor(Long vendorId) {
        return orderRepository.findByVendorId(vendorId);
    }

    public DrugOrder createOrder(DrugOrder order) {
        order.setStatus(OrderStatus.PENDING);
        order.setOrderDate(LocalDateTime.now());
        return orderRepository.save(order);
    }

    public DrugOrder updateOrderStatus(Long id, OrderStatus status) {
        var existing = orderRepository.findById(id).orElseThrow();
        existing.setStatus(status);
        if (status == OrderStatus.DELIVERED) {
            existing.setDeliveryDate(LocalDateTime.now());
            // Optionally, update drug quantity here, but let's keep it simple for now
        }
        return orderRepository.save(existing);
    }
}
