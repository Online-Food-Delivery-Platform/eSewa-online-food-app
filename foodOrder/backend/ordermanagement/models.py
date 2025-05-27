# models.py
from django.db import models
from django.contrib.auth.models import User

class Order(models.Model):
    STATUS_CHOICES = [
        ('PENDING', 'Pending'),
        ('CONFIRMED', 'Confirmed'),
        ('PREPARING', 'Preparing'),
        ('OUT_FOR_DELIVERY', 'Out for Delivery'),
        ('DELIVERED', 'Delivered'),
        ('CANCELLED', 'Cancelled'),
    ]

    user = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    items = models.CharField(max_length=20,default='None')
    number_of_items = models.IntegerField(default=1)
    total_price = models.DecimalField(max_digits=10, decimal_places=2)  # base total (item price * quantity)
    vat = models.DecimalField(max_digits=10, decimal_places=2, default=0.0)
    delivery_charge = models.DecimalField(max_digits=10, decimal_places=2, default=0.0)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='PENDING')

    @property
    def grand_total(self):
        return self.total_price + self.vat + self.delivery_charge

    def __str__(self):
        return f"Order #{self.id} - {self.user.username}"
