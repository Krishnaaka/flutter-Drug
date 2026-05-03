package com.discts.controller;

import com.discts.model.DrugOrder;
import com.discts.model.OrderStatus;
import com.discts.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/orders")
@RequiredArgsConstructor
@CrossOrigin("*")
public class OrderController {

    private final OrderService orderService;

    @GetMapping
    public ResponseEntity<List<DrugOrder>> getAllOrders() {
        return ResponseEntity.ok(orderService.getAllOrders());
    }

    @GetMapping("/hospital/{id}")
    @PreAuthorize("hasRole('HOSPITAL') or hasRole('ADMIN')")
    public ResponseEntity<List<DrugOrder>> getOrdersByHospital(@PathVariable Long id) {
        return ResponseEntity.ok(orderService.getOrdersByHospital(id));
    }

    @GetMapping("/vendor/{id}")
    @PreAuthorize("hasRole('VENDOR') or hasRole('ADMIN')")
    public ResponseEntity<List<DrugOrder>> getOrdersByVendor(@PathVariable Long id) {
        return ResponseEntity.ok(orderService.getOrdersByVendor(id));
    }

    @PostMapping
    @PreAuthorize("hasRole('HOSPITAL')")
    public ResponseEntity<DrugOrder> createOrder(@RequestBody DrugOrder order) {
        return ResponseEntity.ok(orderService.createOrder(order));
    }

    @PutMapping("/{id}/status")
    @PreAuthorize("hasRole('VENDOR') or hasRole('ADMIN')")
    public ResponseEntity<DrugOrder> updateOrderStatus(
            @PathVariable Long id, 
            @RequestParam OrderStatus status) {
        return ResponseEntity.ok(orderService.updateOrderStatus(id, status));
    }
}
