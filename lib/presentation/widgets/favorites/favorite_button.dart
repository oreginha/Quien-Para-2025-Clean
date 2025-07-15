import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/progressive_injection.dart';
import '../../bloc/favorites/favorites_bloc.dart';
import '../../bloc/favorites/favorites_event.dart';
import '../../bloc/favorites/favorites_state.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';

class FavoriteButton extends StatefulWidget {
  final String planId;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showAnimation;
  final VoidCallback? onToggle;

  const FavoriteButton({
    super.key,
    required this.planId,
    this.size = 24.0,
    this.activeColor,
    this.inactiveColor,
    this.showAnimation = true,
    this.onToggle,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Verificar estado inicial del favorito
    _checkInitialFavoriteStatus();
  }

  void _checkInitialFavoriteStatus() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthenticatedState) {
      // Primero verificar cache
      final favoritesBloc = context.read<FavoritesBloc>();
      final cachedStatus = favoritesBloc.getCachedFavoriteStatus(widget.planId);
      
      if (cachedStatus != null) {
        setState(() {
          _isFavorite = cachedStatus;
        });
      } else {
        // Si no está en cache, verificar en servidor
        favoritesBloc.add(CheckSingleFavoriteStatus(
          userId: authState.user.id,
          planId: widget.planId,
        ));
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapFavorite() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthenticatedState) {
      // TODO: Mostrar dialog de login
      return;
    }

    if (_isLoading) return;

    // Animación
    if (widget.showAnimation) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }

    // Toggle favorito
    context.read<FavoritesBloc>().add(ToggleFavorite(
      userId: authState.user.id,
      planId: widget.planId,
    ));

    // Callback opcional
    widget.onToggle?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = widget.activeColor ?? theme.colorScheme.primary;
    final inactiveColor = widget.inactiveColor ?? theme.colorScheme.outline;

    return BlocListener<FavoritesBloc, FavoritesState>(
      listener: (context, state) {
        if (state is FavoriteToggleLoading && state.planId == widget.planId) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is FavoriteToggleSuccess && state.planId == widget.planId) {
          setState(() {
            _isLoading = false;
            _isFavorite = state.isFavorite;
          });
        } else if (state is FavoriteToggleError && state.planId == widget.planId) {
          setState(() {
            _isLoading = false;
          });
          // TODO: Mostrar snackbar de error
        } else if (state is FavoriteCheckLoaded) {
          final status = state.favoriteStatus[widget.planId];
          if (status != null) {
            setState(() {
              _isFavorite = status;
            });
          }
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.showAnimation ? _scaleAnimation.value : 1.0,
            child: InkWell(
              onTap: _onTapFavorite,
              borderRadius: BorderRadius.circular(widget.size),
              child: Container(
                width: widget.size * 1.5,
                height: widget.size * 1.5,
                decoration: BoxDecoration(
                  color: _isFavorite ? activeColor.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(widget.size),
                ),
                child: _isLoading
                    ? SizedBox(
                        width: widget.size,
                        height: widget.size,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(activeColor),
                        ),
                      )
                    : Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: widget.size,
                        color: _isFavorite ? activeColor : inactiveColor,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
