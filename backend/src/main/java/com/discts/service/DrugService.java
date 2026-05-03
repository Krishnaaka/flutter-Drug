package com.discts.service;

import com.discts.model.Drug;
import com.discts.repository.DrugRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DrugService {

    private final DrugRepository drugRepository;

    public List<Drug> getAllDrugs() {
        return drugRepository.findAll();
    }

    public List<Drug> getLowStockDrugs() {
        return drugRepository.findLowStockDrugs();
    }

    public Drug addDrug(Drug drug) {
        return drugRepository.save(drug);
    }

    public Drug updateDrug(Long id, Drug updatedDrug) {
        var existing = drugRepository.findById(id).orElseThrow();
        existing.setName(updatedDrug.getName());
        existing.setCategory(updatedDrug.getCategory());
        existing.setPrice(updatedDrug.getPrice());
        existing.setQuantity(updatedDrug.getQuantity());
        existing.setManufacturer(updatedDrug.getManufacturer());
        return drugRepository.save(existing);
    }

    public void deleteDrug(Long id) {
        drugRepository.deleteById(id);
    }
}
