from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, IsAdminUser
from rest_framework.response import Response
from rest_framework import status
from .models import Order
from .serializers import OrderSerializer


# User - Track Specific Order
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def track_order(request, order_id):
    try:
        order = Order.objects.get(id=order_id, user=request.user)
        serializer = OrderSerializer(order)
        return Response(serializer.data)
    except Order.DoesNotExist:
        return Response({'error': 'Order not found'}, status=404)

# Admin - Update Order Status
@api_view(['PATCH'])
@permission_classes([IsAdminUser])
def update_order_status(request, order_id):
    try:
        order = Order.objects.get(id=order_id)
    except Order.DoesNotExist:
        return Response({'error': 'Order not found'}, status=404)

    new_status = request.data.get('status')
    if new_status in dict(Order.STATUS_CHOICES):
        order.status = new_status
        order.save()
        return Response({'message': f'Status updated to {new_status}'})
    return Response({'error': 'Invalid status'}, status=400)

# User - Create New Order
# views.py (create_order function)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_order(request):
    data = request.data.copy()
    data['user'] = request.user.id

    # Optionally compute VAT (13%) and Delivery Charge (flat rate)
    try:
        base_price = float(data.get('total_price', 0))
        vat = round(base_price * 0.13, 2)
        delivery_charge = 50.00  # flat rate, example
        data['vat'] = vat
        data['delivery_charge'] = delivery_charge
    except:
        return Response({'error': 'Invalid total price'}, status=400)

    serializer = OrderSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=400)


# Admin - View All Orders
@api_view(['GET'])
@permission_classes([IsAdminUser])
def list_all_orders(request):
    orders = Order.objects.all().order_by('-created_at')
    serializer = OrderSerializer(orders, many=True)
    return Response(serializer.data)

# User - View My Orders
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def list_my_orders(request):
    orders = Order.objects.filter(user=request.user).order_by('-created_at')
    serializer = OrderSerializer(orders, many=True)
    return Response(serializer.data)
