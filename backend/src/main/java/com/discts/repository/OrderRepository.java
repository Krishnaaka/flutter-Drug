package com.discts.repository;

import com.discts.model.DrugOrder;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<DrugOrder, Long> {
    List<DrugOrder> findByHospitalId(Long hospitalId);
    List<DrugOrder> findByVendorId(Long vendorId);
}
