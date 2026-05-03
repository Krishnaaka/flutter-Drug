package com.discts.repository;

import com.discts.model.Drug;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DrugRepository extends JpaRepository<Drug, Long> {
    
    // Custom query to find drugs with low stock (e.g., quantity < 50)
    @Query("SELECT d FROM Drug d WHERE d.quantity < 50")
    List<Drug> findLowStockDrugs();
}
