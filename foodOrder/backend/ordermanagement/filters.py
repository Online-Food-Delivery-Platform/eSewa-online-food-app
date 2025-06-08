import django_filters
from .models import Restaurant, FoodItem

class RestaurantFilter(django_filters.FilterSet):
    name = django_filters.CharFilter(field_name='name',lookup_expr='icontains')  # Case-insensitive contains filter
    location = django_filters.CharFilter(lookup_expr='icontains')

    class Meta:
        model = Restaurant
        fields = ['name', 'location']

class FoodItemFilter(django_filters.FilterSet):
    name = django_filters.CharFilter(lookup_expr='icontains')
    category__name = django_filters.CharFilter(field_name='category__name', lookup_expr='icontains')
    restaurant__name = django_filters.CharFilter(field_name='restaurant__name', lookup_expr='icontains')

    class Meta:
        model = FoodItem
        fields = ['name', 'category__name', 'restaurant__name']
