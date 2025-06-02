from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, IsAdminUser
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.models import User
from .models import Restaurant, FoodItem, Category, Order, OrderItem, Review, Profile
from .serializers import (
    UserSerializer, ProfileSerializer,
    RestaurantSerializer, FoodItemSerializer, CategorySerializer,
    OrderSerializer, OrderItemSerializer, ReviewSerializer
)
from django.shortcuts import get_object_or_404
from rest_framework.authtoken.models import Token
from rest_framework.authentication import TokenAuthentication

from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAdminUser

@api_view(['GET'])
@permission_classes([IsAdminUser])
def list_all_orders(request):
    """
    List all orders for admins only.
    """
    orders = Order.objects.all().order_by('-created_at')
    serializer = OrderSerializer(orders, many=True)
    return Response(serializer.data)


@api_view(['PATCH'])
@permission_classes([IsAdminUser])
def update_order_status(request, order_id):
    """
    Admin updates the status of an order.
    Expected payload: { "status": "DELIVERED" } or similar
    """
    order = get_object_or_404(Order, id=order_id)

    status_value = request.data.get('status')
    if not status_value:
        return Response({'error': 'Status is required.'}, status=400)

    order.status = status_value
    order.save()

    serializer = OrderSerializer(order)
    return Response(serializer.data)

# --- USER REGISTRATION AND PROFILE ---

@api_view(['POST'])
def register_user(request):
    """
    Register new user (normal user or owner via is_owner flag)
    """
    serializer = UserSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.save()
        # Create Profile automatically with is_owner if provided
        is_owner = request.data.get('is_owner', False)
        Profile.objects.create(user=user, is_owner=is_owner)
        # Optionally create auth token here if using token auth
        token, created = Token.objects.get_or_create(user=user)
        return Response({'user': serializer.data, 'token': token.key}, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=400)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_profile(request):
    profile = get_object_or_404(Profile, user=request.user)
    serializer = ProfileSerializer(profile)
    return Response(serializer.data)

# --- RESTAURANTS & FOOD ITEMS ---

@api_view(['GET'])
def list_restaurants(request):
    restaurants = Restaurant.objects.all()
    serializer = RestaurantSerializer(restaurants, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def list_food_items(request, restaurant_id):
    food_items = FoodItem.objects.filter(restaurant_id=restaurant_id)
    serializer = FoodItemSerializer(food_items, many=True)
    return Response(serializer.data)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_restaurant(request):
    """
    Only allow owners/admins to create restaurants
    """
    profile = get_object_or_404(Profile, user=request.user)
    if not profile.is_owner:
        return Response({'error': 'Only restaurant owners can create restaurants.'}, status=403)

    data = request.data.copy()
    data['owner'] = request.user.id
    serializer = RestaurantSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)
    return Response(serializer.errors, status=400)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_food_item(request, restaurant_id):
    profile = get_object_or_404(Profile, user=request.user)
    if not profile.is_owner:
        return Response({'error': 'Only restaurant owners can add food items.'}, status=403)

    # Confirm owner owns this restaurant
    restaurant = get_object_or_404(Restaurant, id=restaurant_id, owner=request.user)

    data = request.data.copy()
    data['restaurant'] = restaurant_id

    serializer = FoodItemSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)
    return Response(serializer.errors, status=400)

# --- REVIEWS ---

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_review(request, restaurant_id):
    data = request.data.copy()
    data['user'] = request.user.id
    data['restaurant'] = restaurant_id
    serializer = ReviewSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)
    return Response(serializer.errors, status=400)

@api_view(['GET'])
def list_reviews(request, restaurant_id):
    reviews = Review.objects.filter(restaurant_id=restaurant_id)
    serializer = ReviewSerializer(reviews, many=True)
    return Response(serializer.data)

# --- ORDERS & ORDER ITEMS ---

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_order(request):
    """
    Expect payload like:
    {
        "restaurant": 1,
        "items": [
            {"food_item": 10, "quantity": 2},
            {"food_item": 15, "quantity": 1}
        ]
    }
    """

    user = request.user
    restaurant_id = request.data.get('restaurant')
    items = request.data.get('items')

    if not restaurant_id or not items:
        return Response({'error': 'restaurant and items are required'}, status=400)

    restaurant = get_object_or_404(Restaurant, id=restaurant_id)

    # Calculate totals
    total_items_price = 0
    order_items_data = []

    for item in items:
        food_item = get_object_or_404(FoodItem, id=item['food_item'], restaurant=restaurant)
        quantity = item.get('quantity', 1)
        item_total = food_item.price * quantity
        total_items_price += item_total
        order_items_data.append({
            'food_item': food_item,
            'quantity': quantity,
            'total_price': item_total
        })

    # Calculate VAT and delivery charges based on restaurant
    vat = round(total_items_price * (restaurant.vat_percent / 100), 2)
    delivery_charge = 50.00  # example flat rate or use restaurant min order fee?

    # Create Order
    order = Order.objects.create(
        user=user,
        restaurant=restaurant,
        status='PENDING',
        delivery_charge=delivery_charge,
        vat=vat
    )

    # Create OrderItems
    for item in order_items_data:
        OrderItem.objects.create(
            order=order,
            food_item=item['food_item'],
            quantity=item['quantity']
        )

    serializer = OrderSerializer(order)
    return Response(serializer.data, status=201)

# Your existing track_order, update_order_status, list_all_orders, list_my_orders here ...

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def list_my_orders(request):
    orders = Order.objects.filter(user=request.user).order_by('-created_at')
    serializer = OrderSerializer(orders, many=True)
    return Response(serializer.data)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def track_order(request, order_id):
    try:
        order = Order.objects.get(id=order_id, user=request.user)
    except Order.DoesNotExist:
        return Response({'error': 'Order not found.'}, status=404)

    serializer = OrderSerializer(order)
    return Response(serializer.data)


from rest_framework import viewsets
from django_filters.rest_framework import DjangoFilterBackend
from .models import Restaurant, FoodItem
from .serializers import RestaurantSerializer, FoodItemSerializer
from .filters import RestaurantFilter, FoodItemFilter

class RestaurantViewSet(viewsets.ModelViewSet):
    queryset = Restaurant.objects.all()
    serializer_class = RestaurantSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_class = RestaurantFilter

class FoodItemViewSet(viewsets.ModelViewSet):
    queryset = FoodItem.objects.all()
    serializer_class = FoodItemSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_class = FoodItemFilter
