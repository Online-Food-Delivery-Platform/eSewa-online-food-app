# serializers.py
from rest_framework import serializers
from .models import Order

class OrderSerializer(serializers.ModelSerializer):
    grand_total = serializers.SerializerMethodField()

    class Meta:
        model = Order
        fields = ['id', 'user', 'created_at', 'number_of_items', 'total_price', 'vat', 'delivery_charge', 'status', 'grand_total']

    def get_grand_total(self, obj):
        return obj.grand_total
