do
	local PANEL = vgui.Register("pac_horizontal_scrollbar", {}, "Panel")

	AccessorFunc( PANEL, "m_HideButtons", "HideButtons" )

	function PANEL:Init()

		self.Offset = 0
		self.Scroll = 0
		self.CanvasSize = 1
		self.BarSize = 1

		self.btnLeft = vgui.Create( "DButton", self )
		self.btnLeft:SetText( "" )
		self.btnLeft.DoClick = function( self ) self:GetParent():AddScroll( -1 ) end
		self.btnLeft.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "ButtonLeft", panel, w, h ) end

		self.btnRight = vgui.Create( "DButton", self )
		self.btnRight:SetText( "" )
		self.btnRight.DoClick = function( self ) self:GetParent():AddScroll( 1 ) end
		self.btnRight.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "ButtonRight", panel, w, h ) end

		self.btnGrip = vgui.Create( "DScrollBarGrip", self )
		self.btnGrip.Paint = function(panel,w,h)
			local skin = panel:GetSkin()
			if ( panel:GetDisabled() ) then
				skin.tex.Scroller.ButtonH_Disabled( 0, 0, w, h )
			elseif ( panel.Depressed ) then
				return skin.tex.Scroller.ButtonH_Down( 0, 0, w, h )
			elseif ( panel.Hovered ) then
				return skin.tex.Scroller.ButtonH_Hover( 0, 0, w, h )
			else
				skin.tex.Scroller.ButtonH_Normal( 0, 0, w, h )
			end

			return true
		end

		self:SetSize( 15, 15 )
		self:SetHideButtons( false )

	end

	function PANEL:SetEnabled( b )

		if ( !b ) then

			self.Offset = 0
			self:SetScroll( 0 )
			self.HasChanged = true

		end

		self:SetMouseInputEnabled( b )
		self:SetVisible( b )

		-- We're probably changing the width of something in our parent
		-- by appearing or hiding, so tell them to re-do their layout.
		if ( self.Enabled != b ) then

			self:GetParent():InvalidateLayout()

			if ( self:GetParent().OnScrollbarAppear ) then
				self:GetParent():OnScrollbarAppear()
			end

		end

		self.Enabled = b

	end

	function PANEL:Value()

		return self.Pos

	end

	function PANEL:BarScale()

		if ( self.BarSize == 0 ) then return 1 end

		return self.BarSize / ( self.CanvasSize + self.BarSize )

	end

	function PANEL:SetUp( _barsize_, _canvassize_ )

		self.BarSize = _barsize_
		self.CanvasSize = math.max( _canvassize_ - _barsize_, 1 )

		self:SetEnabled( _canvassize_ > _barsize_ )

		self:InvalidateLayout()

	end

	function PANEL:OnMouseWheeled( dlta )

		if ( !self:IsVisible() ) then return false end

		-- We return true if the scrollbar changed.
		-- If it didn't, we feed the mousehweeling to the parent panel

		return self:AddScroll( dlta * -2 )

	end

	function PANEL:AddScroll( dlta )

		local OldScroll = self:GetScroll()

		dlta = dlta * 25
		self:SetScroll( self:GetScroll() + dlta )

		return OldScroll != self:GetScroll()

	end

	function PANEL:SetScroll( scrll )

		if ( !self.Enabled ) then self.Scroll = 0 return end

		self.Scroll = math.Clamp( scrll, 0, self.CanvasSize )

		self:InvalidateLayout()

		-- If our parent has a OnVScroll function use that, if
		-- not then invalidate layout (which can be pretty slow)

		local func = self:GetParent().OnVScroll
		if ( func ) then

			func( self:GetParent(), self:GetOffset() )

		else

			self:GetParent():InvalidateLayout()

		end

	end

	function PANEL:AnimateTo( scrll, length, delay, ease )

		local anim = self:NewAnimation( length, delay, ease )
		anim.StartPos = self.Scroll
		anim.TargetPos = scrll
		anim.Think = function( anim, pnl, fraction )

			pnl:SetScroll( Lerp( fraction, anim.StartPos, anim.TargetPos ) )

		end

	end

	function PANEL:GetScroll()

		if ( !self.Enabled ) then self.Scroll = 0 end
		return self.Scroll

	end

	function PANEL:GetOffset()

		if ( !self.Enabled ) then return 0 end
		return self.Scroll * -1

	end

	function PANEL:Think()
	end

	function PANEL:Paint( w, h )

		self:GetSkin().tex.Scroller.TrackH(0,0,w,h)
		return true

	end

	function PANEL:OnMousePressed()

		local x, y = self:CursorPos()

		local PageSize = self.BarSize

		if ( x > self.btnGrip.x ) then
			self:SetScroll( self:GetScroll() + PageSize )
		else
			self:SetScroll( self:GetScroll() - PageSize )
		end

	end

	function PANEL:OnMouseReleased()

		self.Dragging = false
		self.DraggingCanvas = nil
		self:MouseCapture( false )

		self.btnGrip.Depressed = false

	end

	function PANEL:OnCursorMoved( x, y )

		if ( !self.Enabled ) then return end
		if ( !self.Dragging ) then return end

		local x, y = self:ScreenToLocal( gui.MouseX(), 0 )

		-- Uck.
		x = x - self.btnLeft:GetWide()
		x = x - self.HoldPos

		local BtnHeight = self:GetTall()
		if ( self:GetHideButtons() ) then BtnHeight = 0 end

		local TrackSize = self:GetWide() - BtnHeight * 2 - self.btnGrip:GetWide()

		x = x / TrackSize

		self:SetScroll( x * self.CanvasSize )

	end

	function PANEL:Grip()

		if ( !self.Enabled ) then return end
		if ( self.BarSize == 0 ) then return end

		self:MouseCapture( true )
		self.Dragging = true

		local x, y = self.btnGrip:ScreenToLocal( gui.MouseX(), 0 )
		self.HoldPos = x

		self.btnGrip.Depressed = true

	end

	function PANEL:PerformLayout()

		local Wide = self:GetTall()
		local BtnHeight = Wide
		if ( self:GetHideButtons() ) then BtnHeight = 0 end
		local Scroll = self:GetScroll() / self.CanvasSize
		local BarSize = math.max( self:BarScale() * ( self:GetWide() - ( BtnHeight * 2 ) ), 10 )
		local Track = self:GetWide() - ( BtnHeight * 2 ) - BarSize
		Track = Track + 1

		Scroll = Scroll * Track

		self.btnGrip:SetPos( BtnHeight + Scroll, 0 )
		self.btnGrip:SetSize( BarSize, Wide )

		if ( BtnHeight > 0 ) then
			self.btnLeft:SetPos( 0, 0, Wide, Wide )
			self.btnLeft:SetSize( BtnHeight, Wide )

			self.btnRight:SetPos( self:GetWide() - BtnHeight, 0 )
			self.btnRight:SetSize(BtnHeight, Wide )

			self.btnLeft:SetVisible( true )
			self.btnRight:SetVisible( true )
		else
			self.btnLeft:SetVisible( false )
			self.btnRight:SetVisible( false )
			self.btnRight:SetSize( BtnHeight, Wide )
			self.btnLeft:SetSize( BtnHeight, Wide )
		end

	end
end


do
	local PANEL = vgui.Register("pac_scrollpanel_horizontal", {}, "DPanel")

	AccessorFunc( PANEL, "Padding", "Padding" )
	AccessorFunc( PANEL, "pnlCanvas", "Canvas" )

	function PANEL:Init()

		self.pnlCanvas = vgui.Create( "Panel", self )
		self.pnlCanvas.OnMousePressed = function( self, code ) self:GetParent():OnMousePressed( code ) end
		self.pnlCanvas:SetMouseInputEnabled( true )
		self.pnlCanvas.PerformLayout = function( pnl )

			self:PerformLayout()
			self:InvalidateParent()

		end

		-- Create the scroll bar
		self.VBar = vgui.Create( "pac_horizontal_scrollbar", self )
		self.VBar:Dock( BOTTOM )

		self:SetPadding( 0 )
		self:SetMouseInputEnabled( true )

		-- This turns off the engine drawing
		self:SetPaintBackgroundEnabled( false )
		self:SetPaintBorderEnabled( false )
		self:SetPaintBackground( false )

	end

	function PANEL:AddItem( pnl )

		pnl:SetParent( self:GetCanvas() )

	end

	function PANEL:OnChildAdded( child )

		self:AddItem( child )

	end

	function PANEL:SizeToContents()

		self:SetSize( self.pnlCanvas:GetSize() )

	end

	function PANEL:GetVBar()

		return self.VBar

	end

	function PANEL:GetCanvas()

		return self.pnlCanvas

	end

	function PANEL:InnerWidth()

		return self:GetCanvas():GetTall()

	end

	function PANEL:Rebuild()

		self:GetCanvas():SizeToChildren( true, false )

		-- Although this behaviour isn't exactly implied, center vertically too
		if ( self.m_bNoSizing && self:GetCanvas():GetWide() < self:GetWide() ) then

			self:GetCanvas():SetPos( ( self:GetWide() - self:GetCanvas():GetWide() ) * 0.5, 0 )

		end

	end

	function PANEL:OnMouseWheeled( dlta )

		return self.VBar:OnMouseWheeled( dlta )

	end

	function PANEL:OnVScroll( iOffset )

		self.pnlCanvas:SetPos( iOffset, 0 )

	end

	function PANEL:ScrollToChild( panel )

		self:PerformLayout()

		local x, y = self.pnlCanvas:GetChildPosition( panel )
		local w, h = panel:GetSize()

		x = x + w * 0.5
		x = x - self:GetWide() * 0.5

		self.VBar:AnimateTo( x, 0.5, 0, 0.5 )

	end

	function PANEL:PerformLayout()

		local Tall = self.pnlCanvas:GetWide()
		local Wide = self:GetWide()
		local YPos = 0

		self:Rebuild()

		self.VBar:SetUp( self:GetWide(), self.pnlCanvas:GetWide() )
		YPos = self.VBar:GetOffset()

		if ( self.VBar.Enabled ) then Wide = Wide - self.VBar:GetWide() end

		self.pnlCanvas:SetPos( YPos, 0 )
		self.pnlCanvas:SetWide( Wide )

		self:Rebuild()

		if ( Tall != self.pnlCanvas:GetWide() ) then
			self.VBar:SetScroll( self.VBar:GetScroll() ) -- Make sure we are not too far down!
		end

	end

	function PANEL:Clear()

		return self.pnlCanvas:Clear()

	end
end