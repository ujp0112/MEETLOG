package com.meetlog.repository;

import com.meetlog.dto.payment.PaymentDto;
import com.meetlog.model.Payment;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Payment Repository Interface
 * MyBatis 매퍼와 연동
 */
@Mapper
public interface PaymentRepository {

    // CRUD
    Payment findById(@Param("id") Long id);
    Payment findByOrderId(@Param("orderId") String orderId);
    PaymentDto findDtoById(@Param("id") Long id);
    List<PaymentDto> findByUserId(@Param("userId") Long userId, @Param("page") int page, @Param("size") int size);
    List<PaymentDto> findByReference(@Param("paymentType") String paymentType, @Param("referenceId") Long referenceId);
    int insert(Payment payment);
    int update(Payment payment);
    int updateStatus(@Param("id") Long id, @Param("status") String status);

    // Statistics
    int countByUserId(@Param("userId") Long userId);
}
