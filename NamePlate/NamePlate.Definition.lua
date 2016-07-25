-----------------------------------------
-- Definition for NamePlate
-----------------------------------------
IGAS:NewAddon "IGAS_UI.NamePlate"

class "iNamePlateUnitFrame"
	inherit "Button"
	extend "IFContainer"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function AddElement(self, ...)
		IFContainer.AddWidget(self, ...)
		self:Each("Unit", self.Unit)
	end

	function InsertElement(self, ...)
		IFContainer.InsertWidget(self, ...)
		self:Each("Unit", self.Unit)
	end

	function GetElement(self, ...)
		return IFContainer.GetWidget(self, ...)
	end

	function RemoveElement(self, ...)
		return IFContainer.RemoveWidget(self, ...)
	end

	function UpdateElements(self)
		self:Each("Refresh")
	end

	function ApplyFrameOptions(self, verticalScale, horizontalScale)
		verticalScale = verticalScale or 1.0
		horizontalScale = horizontalScale or 1.0

		self:SuspendLayout()

		-- Apply Config
		for _, set in ipairs(Config.Elements) do
			local obj

			-- Create element
			if set.Name then
				if set.Direction then
					local size = set.Size

					if set.Unit == "px" then
						if set.Direction == "south" or set.Direction == "north" then
							size = size * verticalScale
						else
							size = size * horizontalScale
						end
					end

					self:AddElement(set.Name, set.Type, set.Direction, size, set.Unit)
				else
					self:AddElement(set.Name, set.Type)
				end
				obj = self:GetElement(set.Name)
			else
				if set.Direction then
					local size = set.Size

					if set.Unit == "px" then
						if set.Direction == "south" or set.Direction == "north" then
							size = size * verticalScale
						else
							size = size * horizontalScale
						end
					end

					self:AddElement(set.Type, set.Direction, size, set.Unit)
				else
					self:AddElement(set.Type)
				end
				obj = self:GetElement(set.Type)
			end

			-- Apply init
			if type(set.Init) == "function" then
				pcall(set.Init, obj)
			end

			-- Apply Size
			if set.Size then
				pcall(setProperty, obj, "Size", set.Size)
			end

			-- Apply Location
			if not set.Direction and set.Location then
				obj.Location = set.Location
			end

			-- Apply Property
			if set.Property then
				pcall(obj, set.Property)
			end

			-- Apply Frame Options
			if set.ApplyFrameOptions then
				pcall(set.ApplyFrameOptions, obj, verticalScale, horizontalScale)
			end
		end

		self:ResumeLayout()
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	property "Unit" { Type = String,
		Handler = function(self, unit)
			self:Each("Unit", unit)
		end
	}

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local abs = math.abs

	local function OnShow(self)
		self:UpdateElements()
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iNamePlateUnitFrame(self, ...)
		Super(self, ...)

		self:SetPoint("BOTTOMLEFT")
		self:SetPoint("BOTTOMRIGHT")
		self.Height = 300  -- Make sure it can contains everything

		self.Layout = DockLayoutPanel
		self.AutoLayout = true
		self.MouseEnabled = false

		self.Panel.VSpacing = Config.PANEL_VSPACING or 0
		self.Panel.HSpacing = Config.PANEL_HSPACING or 0

		self.OnShow = self.OnShow + OnShow
	end

	------------------------------------------------------
	-- __index
	------------------------------------------------------
	local sindex = Super.__index
	local getwidget = IFContainer.GetWidget
    function __index(self, key) return sindex(self, key) or getwidget(self, key) end
endclass "iNamePlateUnitFrame"